
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

DROP FUNCTION IF EXISTS public.assign_role;
DROP TRIGGER IF EXISTS on_tenant_created ON public.tenants;
DROP FUNCTION IF EXISTS public.handle_new_tenant;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user;
DROP FUNCTION IF EXISTS public.has_permission;
DROP FUNCTION IF EXISTS public.has_role;

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
  name VARCHAR CHECK (name <> ''),
  email TEXT UNIQUE NOT NULL CHECK (email <> ''), 
  username VARCHAR UNIQUE CHECK (username <> ''),
  ronin_address VARCHAR(42) UNIQUE CHECK (ronin_address <> ''),
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP
);
COMMENT ON COLUMN public.users.id IS 'The auth.users reference';

-- user_role
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
  FROM user_roles AS a
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
  IF NOT public.has_role('super_admin') THEN 
      RAISE EXCEPTION 'Not authorized to perform this action';
  END IF;

  INSERT INTO user_role (user_id, role_id) VALUES ($1::uuid, (SELECT id FROM roles WHERE name = $2 LIMIT 1)::uuid);

  RETURN;
END
$$ LANGUAGE plpgsql SECURITY DEFINER; 