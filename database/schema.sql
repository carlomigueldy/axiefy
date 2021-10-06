DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TABLE IF EXISTS public.users;

-- users
CREATE TABLE public.users (
  id uuid PRIMARY KEY NOT NULL REFERENCES auth.users (id),
  name VARCHAR CHECK (name <> ''),
  email TEXT UNIQUE NOT NULL CHECK (email <> ''), 
  username VARCHAR UNIQUE CHECK (username <> ''),
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at TIMESTAMP
);

COMMENT ON COLUMN public.users.id IS 'The auth.users reference';

-- Trigger to handle new registered user
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