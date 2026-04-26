-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.applications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  student_id uuid NOT NULL,
  cover_letter text NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::application_status,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  deliverable_link text,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  cv_url text,
  cv_name text,
  CONSTRAINT applications_pkey PRIMARY KEY (id),
  CONSTRAINT applications_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id),
  CONSTRAINT applications_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.credentials (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL,
  business_id uuid NOT NULL,
  project_id uuid NOT NULL,
  skills_verified ARRAY NOT NULL DEFAULT ARRAY[]::text[],
  feedback text,
  rating integer CHECK (rating >= 1 AND rating <= 5),
  issued_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT credentials_pkey PRIMARY KEY (id),
  CONSTRAINT credentials_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id),
  CONSTRAINT credentials_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.profiles(id),
  CONSTRAINT credentials_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.employer_references (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL,
  employer_id uuid NOT NULL,
  project_id uuid NOT NULL,
  student_name text NOT NULL,
  employer_name text NOT NULL,
  employer_title text NOT NULL,
  company_name text NOT NULL,
  company_logo text,
  project_title text NOT NULL,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  work_quality integer NOT NULL CHECK (work_quality >= 1 AND work_quality <= 5),
  communication integer NOT NULL CHECK (communication >= 1 AND communication <= 5),
  professionalism integer NOT NULL CHECK (professionalism >= 1 AND professionalism <= 5),
  technical_skills integer NOT NULL CHECK (technical_skills >= 1 AND technical_skills <= 5),
  skills ARRAY NOT NULL DEFAULT ARRAY[]::text[],
  strengths ARRAY NOT NULL DEFAULT ARRAY[]::text[],
  areas_for_improvement ARRAY NOT NULL DEFAULT ARRAY[]::text[],
  overall_feedback text NOT NULL,
  would_work_again boolean NOT NULL DEFAULT false,
  is_public boolean NOT NULL DEFAULT true,
  verified_by_platform boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT employer_references_pkey PRIMARY KEY (id),
  CONSTRAINT employer_references_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id),
  CONSTRAINT employer_references_employer_id_fkey FOREIGN KEY (employer_id) REFERENCES public.profiles(id),
  CONSTRAINT employer_references_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL,
  sender_id uuid NOT NULL,
  receiver_id uuid NOT NULL,
  content text NOT NULL,
  read boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id),
  CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.profiles(id),
  CONSTRAINT messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.notifications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  type text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  action_url text,
  is_read boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  role USER-DEFINED NOT NULL DEFAULT 'student'::user_role,
  full_name text NOT NULL,
  university_id uuid,
  company_name text,
  bio text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  skills ARRAY DEFAULT ARRAY[]::text[],
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  cv_url text,
  cv_name text,
  website text,
  is_verified boolean DEFAULT false,
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id),
  CONSTRAINT profiles_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.projects (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  business_id uuid NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  deliverables text NOT NULL,
  required_skills ARRAY NOT NULL DEFAULT ARRAY[]::text[],
  budget numeric NOT NULL DEFAULT 0.00,
  payment_status USER-DEFINED NOT NULL DEFAULT 'pending'::payment_status,
  stripe_payment_intent_id text,
  duration_hours integer NOT NULL DEFAULT 0,
  status USER-DEFINED NOT NULL DEFAULT 'open'::project_status,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  project_documents_url text,
  category text,
  deadline timestamp with time zone,
  CONSTRAINT projects_pkey PRIMARY KEY (id),
  CONSTRAINT projects_business_id_fkey FOREIGN KEY (business_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.reference_requests (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  student_id uuid NOT NULL,
  employer_id uuid NOT NULL,
  project_id uuid NOT NULL,
  student_name text NOT NULL,
  project_title text NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::reference_request_status,
  requested_at timestamp with time zone NOT NULL DEFAULT now(),
  completed_at timestamp with time zone,
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT reference_requests_pkey PRIMARY KEY (id),
  CONSTRAINT reference_requests_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.profiles(id),
  CONSTRAINT reference_requests_employer_id_fkey FOREIGN KEY (employer_id) REFERENCES public.profiles(id),
  CONSTRAINT reference_requests_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id)
);
CREATE TABLE public.user_feedback (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  category text NOT NULL,
  content text NOT NULL,
  status text NOT NULL DEFAULT 'new'::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT user_feedback_pkey PRIMARY KEY (id),
  CONSTRAINT user_feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);