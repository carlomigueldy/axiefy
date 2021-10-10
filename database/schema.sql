
ALTER DATABASE postgres 
SET timezone TO 'Asia/Singapore';

DROP POLICY IF EXISTS "Read Policy" ON public.roles;
DROP POLICY IF EXISTS "Insert Policy" ON public.roles;
DROP POLICY IF EXISTS "Update Policy" ON public.roles;
DROP POLICY IF EXISTS "Delete Policy" ON public.roles;
DROP POLICY IF EXISTS "Read Policy" ON public.permissions;
DROP POLICY IF EXISTS "Insert Policy" ON public.permissions;
DROP POLICY IF EXISTS "Update Policy" ON public.permissions;
DROP POLICY IF EXISTS "Delete Policy" ON public.permissions;
DROP POLICY IF EXISTS "Read Policy" ON public.role_permission;
DROP POLICY IF EXISTS "Insert Policy" ON public.role_permission;
DROP POLICY IF EXISTS "Update Policy" ON public.role_permission;
DROP POLICY IF EXISTS "Delete Policy" ON public.role_permission;
DROP POLICY IF EXISTS "Only authenticated users can read" ON public.users;
DROP POLICY IF EXISTS "Only managers and super admins can insert" ON public.users;
DROP POLICY IF EXISTS "Only managers and super admins can update" ON public.users;
DROP POLICY IF EXISTS "Only super admins can delete" ON public.users;

DROP FUNCTION IF EXISTS public.disable_account;
DROP FUNCTION IF EXISTS public.get_auth_uid;
DROP FUNCTION IF EXISTS public.get_team_members;
DROP FUNCTION IF EXISTS public.assign_role;
DROP TRIGGER IF EXISTS on_tenant_created ON public.tenants;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user;
DROP FUNCTION IF EXISTS public.has_permission;
DROP FUNCTION IF EXISTS public.has_role;

DROP TABLE IF EXISTS public.reviews;
DROP TABLE IF EXISTS public.team_members;
DROP TABLE IF EXISTS public.teams;
DROP TABLE IF EXISTS public.user_role;
DROP TABLE IF EXISTS public.role_permission;
DROP TABLE IF EXISTS public.permissions;
DROP TABLE IF EXISTS public.roles;
DROP TABLE IF EXISTS public.users;

DELETE FROM auth.users;

-- table: roles
CREATE TABLE public.roles (
  id uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
  name VARCHAR(32) UNIQUE NOT NULL CHECK (name <> ''),
  description VARCHAR
);
COMMENT ON TABLE public.roles IS 'Application roles.';

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Read Policy" ON public.roles FOR SELECT USING ( auth.role() = 'authenticated' );
CREATE POLICY "Insert Policy" ON public.roles FOR INSERT WITH CHECK ( false );
CREATE POLICY "Update Policy" ON public.roles FOR UPDATE USING ( false );
CREATE POLICY "Delete Policy" ON public.roles FOR DELETE USING ( false );

INSERT INTO public.roles (name, description) 
VALUES ('super_admin', 'Full access to the entire multi-tenant application'),
('admin', 'Admin access'),
('manager', 'Manager access'),
('scholar', 'Application tenant');

-- table: permissions
CREATE TABLE public.permissions (
  id uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
  name VARCHAR(32) UNIQUE NOT NULL CHECK (name <> ''),
  description VARCHAR
);
COMMENT ON TABLE public.permissions IS 'Application permissions.';

ALTER TABLE public.permissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Read Policy" ON public.permissions FOR SELECT USING ( auth.role() = 'authenticated' );
CREATE POLICY "Insert Policy" ON public.permissions FOR INSERT WITH CHECK ( false );
CREATE POLICY "Update Policy" ON public.permissions FOR UPDATE USING ( false );
CREATE POLICY "Delete Policy" ON public.permissions FOR DELETE USING ( false );

INSERT INTO public.permissions (name) 
VALUES ('users.create'), 
('users.read'),
('users.update'),
('users.delete'),
('users.restore');

-- table: role_permission
CREATE TABLE public.role_permission (
	  role_id uuid NOT NULL REFERENCES roles (id),
	  permission_id uuid NOT NULL REFERENCES permissions (id),
	  PRIMARY KEY (role_id, permission_id)
);
COMMENT ON TABLE public.role_permission IS 'Application permissions for each role.';

ALTER TABLE public.role_permission ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Read Policy" ON public.role_permission FOR SELECT USING ( auth.role() = 'authenticated' );
CREATE POLICY "Insert Policy" ON public.role_permission FOR INSERT WITH CHECK ( false );
CREATE POLICY "Update Policy" ON public.role_permission FOR UPDATE USING ( false );
CREATE POLICY "Delete Policy" ON public.role_permission FOR DELETE USING ( false );

-- seed: assign super_admin permissions
INSERT INTO public.role_permission (role_id, permission_id) 
SELECT 
  (SELECT id FROM public.roles WHERE name = 'super_admin' LIMIT 1) AS role_id, 
  id 
FROM public.permissions;

-- seed: assign admin permissions
INSERT INTO public.role_permission (role_id, permission_id) 
SELECT 
  (SELECT id FROM public.roles WHERE name = 'admin' LIMIT 1) AS role_id, 
  id 
FROM public.permissions;

-- seed: assign manager permissions
INSERT INTO public.role_permission (role_id, permission_id) 
SELECT 
  (SELECT id FROM public.roles WHERE name = 'manager' LIMIT 1) AS role_id, 
  id 
FROM public.permissions
WHERE name NOT IN (
  'users.restore'
);

-- table: users
CREATE TABLE public.users (
  id uuid PRIMARY KEY NOT NULL REFERENCES auth.users (id),
  profile_image_url VARCHAR CHECK (profile_image_url <> ''),
  name VARCHAR CHECK (name <> ''),
  email TEXT UNIQUE NOT NULL CHECK (email <> ''), 
  username VARCHAR UNIQUE CHECK (username <> ''),
  ronin_address VARCHAR(128) UNIQUE CHECK (ronin_address <> ''),
  disabled_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP
);
COMMENT ON COLUMN public.users.id IS 'The auth.users reference';

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Only authenticated users can read" ON public.users FOR SELECT USING ( auth.role() = 'authenticated' );
CREATE POLICY "Only managers and super admins can insert" ON public.users FOR INSERT WITH CHECK ( 
  public.has_role('manager') OR 
  public.has_role('super_admin') OR 
  current_user = 'supabase_admin' 
);
CREATE POLICY "Only managers and super admins can update" ON public.users FOR UPDATE USING ( 
  public.has_role('manager') OR 
  public.has_role('super_admin') OR 
  current_user = 'supabase_admin' 
);
CREATE POLICY "Only super admins can delete" ON public.users FOR DELETE USING ( 
  public.has_role('super_admin') OR current_user = 'supabase_admin' 
);

-- table: user_role
CREATE TABLE public.user_role (
  user_id uuid NOT NULL REFERENCES users (id),
  role_id uuid NOT NULL REFERENCES roles (id),
  PRIMARY KEY (user_id, role_id)
);
COMMENT ON TABLE public.user_role IS 'Each user can have multiple roles.';

-- trigger: handle new registered user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN 
  INSERT INTO public.users (id, email) VALUES (new.id, new.email);

  INSERT INTO public.teams (owner_id) VALUES (new.id); 

  return new;
END
$$
LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.handle_new_user();

-- function: check user role
CREATE OR REPLACE FUNCTION public.has_role(role VARCHAR)
RETURNS boolean AS 
$$
BEGIN 
  IF NOT auth.role() = 'authenticated' THEN 
      RAISE EXCEPTION 'You are not authenticated';
    END IF;

    RETURN EXISTS(
        SELECT role_id 
        FROM user_role AS a
        INNER JOIN roles AS b
        ON a.role_id = b.id
        WHERE a.user_id = auth.uid()
        AND b.name = $1
      );
  END
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- function: check user permission
CREATE OR REPLACE FUNCTION public.has_permission(permission VARCHAR)
RETURNS boolean AS 
$$
BEGIN 
RETURN EXISTS(
  SELECT b.name AS role_name, 
    d.name AS permission_name 
  FROM user_role AS a
    INNER JOIN roles AS b
      ON a.role_id = b.id
      INNER JOIN role_permission AS c 
        ON b.id = c.role_id
        INNER JOIN permissions AS d
          ON c.permission_id = d.id
        WHERE a.user_id = auth.uid()
        AND d.name = $1
  );
END
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- function: assign role to user
CREATE OR REPLACE FUNCTION public.assign_role(user_id uuid, role VARCHAR)
RETURNS void AS 
$$
BEGIN 
  IF current_user::VARCHAR = 'supabase_admin' THEN
    INSERT INTO user_role (user_id, role_id) VALUES ($1::UUID, (SELECT id FROM roles WHERE name = $2 LIMIT 1)::UUID);

    RETURN;
  END IF;

  IF NOT public.has_role('super_admin') THEN 
      RAISE EXCEPTION 'Not authorized to perform this action';
  END IF;

  INSERT INTO user_role (user_id, role_id) VALUES ($1::UUID, (SELECT id FROM roles WHERE name = $2 LIMIT 1)::UUID);

  RETURN;
END
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- table: teams
CREATE TABLE public.teams (
  id uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
  name VARCHAR(64),
  owner_id uuid REFERENCES public.users (id),
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP
);
COMMENT ON COLUMN public.teams.owner_id IS 'The manager/owner that manages scholars.';

-- table: team_members
CREATE TABLE public.team_members (
  user_id uuid NOT NULL REFERENCES public.users (id),
  team_id uuid NOT NULL REFERENCES public.teams (id),
  share SMALLINT CHECK (share <= 100 AND share >= 0 ),
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP,
  PRIMARY KEY (user_id, team_id)
);

-- function: get_team_members
-- todo: to be removed
CREATE OR REPLACE FUNCTION public.get_team_members()
RETURNS SETOF public.get_team_members AS 
$$
BEGIN 
  RETURN QUERY (SELECT * FROM get_team_members);
END
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- view: get_team_members
CREATE VIEW get_team_members AS (
  SELECT users.*, team_members.share AS share
  FROM team_members
  INNER JOIN users 
  ON team_members.user_id = users.id 
  WHERE team_id = (
    SELECT id 
    FROM teams 
    WHERE owner_id = auth.uid()
  )
);
  

-- function: get_auth_uid
-- for testing purposes
CREATE OR REPLACE FUNCTION public.get_auth_uid()
RETURNS uuid AS 
$$
BEGIN 
  RETURN auth.uid();
END
$$ LANGUAGE plpgsql SECURITY DEFINER; 

-- table: reviews
CREATE TABLE public.reviews (
  id uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES public.users (id) DEFAULT auth.uid(),
  message TEXT NOT NULL CHECK (message <> ''),
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP,
  PRIMARY KEY (user_id, team_id)
);
COMMENT ON TABLE public.reviews IS 'User feedback/reviews/feature requests will be recorded here.';

-- function: disable_account
CREATE OR REPLACE FUNCTION public.disable_account(email VARCHAR)
RETURNS void AS 
$$
BEGIN 
  IF NOT EXISTS(SELECT public.users.email FROM public.users WHERE id = auth.uid() AND users.email = $1) THEN
    RAISE EXCEPTION 'No matching email on given input. It must be your email address.';
  END IF;

  UPDATE public.users SET disabled_at = now() WHERE id = auth.uid();
END
$$ LANGUAGE plpgsql SECURITY DEFINER; 