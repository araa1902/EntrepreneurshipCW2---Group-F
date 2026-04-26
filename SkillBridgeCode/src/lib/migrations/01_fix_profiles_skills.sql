ALTER TABLE public.profiles DROP COLUMN IF EXISTS skills;
ALTER TABLE public.profiles ADD COLUMN skills text[] DEFAULT ARRAY[]::text[];
