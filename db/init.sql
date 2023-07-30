CREATE TYPE user_type AS ENUM (
  'admin',
  -- admin
  'group_admin',
  -- グループリーダー
  'school',
  -- 生徒・保護者枠
  'examinee',
  -- 受験生枠
  'general' -- 一般枠
);

CREATE TABLE IF NOT EXISTS public.profiles(
  id UUID PRIMARY KEY REFERENCES auth.users on delete cascade,
  name TEXT,
  email TEXT NOT NULL UNIQUE,
  type user_type,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE
OR REPLACE FUNCTION user_type(_user_id UUID) RETURNS user_type AS $ $
SELECT
  type
FROM
  public.profiles
WHERE
  id = _user_id $ $ LANGUAGE sql SECURITY DEFINER;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow select only own profile" ON public.profiles
FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Allow update only own profile" ON public.profiles
FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Allow select only admin" ON public.profiles
FOR SELECT USING (user_type(auth.uid()) = 'admin');


CREATE TYPE group_type AS ENUM (
  'class',
  -- クラス ,
  'committee',
  -- 委員会,
  'club',
  -- 部活動
  'other' -- その他
);

CREATE TABLE IF NOT EXISTS public.groups(
  id UUID default uuid_generate_v4() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  place TEXT,
  type group_type NOT NULL
);

CREATE TABLE IF NOT EXISTS public.profile_groups(
  group_id UUID REFERENCES public.groups(id),
  user_id UUID REFERENCES public.profiles(id),
  PRIMARY KEY (group_id, user_id)
);


CREATE OR REPLACE FUNCTION is_member_of(_user_id UUID, _group_id UUID)
RETURNS BOOLEAN
AS $$
SELECT EXISTS(
  SELECT 1
  FROM public.profile_groups
  WHERE user_id = _user_id AND group_id = _group_id
)
$$ LANGUAGE sql SECURITY DEFINER;



ALTER TABLE public.profile_groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow select for all users" ON public.profile_groups
FOR SELECT USING (true);
CREATE POLICY "Allow insert for admin" ON public.profile_groups
FOR INSERT WITH CHECK (user_type(auth.uid()) = 'admin');

ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow select for all users" ON public.groups
FOR SELECT USING (true);
CREATE POLICY "Allow update for group member && groupadmin" ON public.groups
FOR UPDATE USING (
 is_member_of(
  auth.uid(),
  id
 ) AND user_type(auth.uid()) = 'group_admin'
);
CREATE POLICY "Allow insert for admin" ON public.groups
FOR INSERT WITH CHECK (user_type(auth.uid()) = 'admin');



CREATE TYPE reservation_type AS ENUM ('item', -- 物品
'food' -- 飲食
);

-- グループ内の予約(物品・飲食)枠
CREATE TABLE IF NOT EXISTS public.reservation_slots(
  id UUID default uuid_generate_v4() PRIMARY KEY,
  group_id UUID REFERENCES public.groups(id),
  name TEXT,
  max_count INTEGER,
  type reservation_type NOT NULL,
  price INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
ALTER TABLE public.reservation_slots ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow select for all users" ON public.reservation_slots
FOR SELECT USING (true);
CREATE POLICY "Allow all for group menber && groupadmin" ON public.reservation_slots
FOR ALL USING (
  is_member_of(
    auth.uid(),
    group_id
  )
  AND user_type(auth.uid()) = 'group_admin'
);
CREATE POLICY "Allow all for admin" ON public.reservation_slots
FOR ALL USING (user_type(auth.uid()) = 'admin');


CREATE TABLE IF NOT EXISTS public.reservations(
  user_id UUID REFERENCES public.profiles(id),
  slot_id UUID REFERENCES public.reservation_slots(id),
  PRIMARY KEY (user_id, slot_id)
);
ALTER TABLE public.reservations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all for user" ON public.reservations
FOR ALL USING (auth.uid() = user_id);


------------------ Functions ------------------
DROP FUNCTION IF EXISTS public.get_profile;

CREATE OR REPLACE FUNCTION public.get_profile()
RETURNS table(
  profile json,
  reservations json[],
  groups json[]
)
LANGUAGE sql
AS $$
SELECT
  to_json(p) as profile,
  array_agg(to_json(s)) as reservations,
  array_agg(to_json(g)) as groups
FROM
  public.profiles as p
  INNER JOIN public.reservations r ON p.id = r.user_id
  INNER JOIN public.reservation_slots s ON r.slot_id = s.id
  INNER JOIN public.groups g ON s.group_id = g.id
WHERE
  p.id = auth.uid()
GROUP BY
  p.id
$$;

DROP FUNCTION IF EXISTS public.get_group;
CREATE OR REPLACE FUNCTION public.get_group(_group_id UUID)
RETURNS table(
  groups json,
  slots json[]
)
LANGUAGE sql
AS $$

SELECT
  to_json(g) as group,
  array_agg(to_json(s)) as slots
FROM
  public.groups as g
  INNER JOIN public.reservation_slots s ON g.id = s.group_id
WHERE
  g.id = _group_id
GROUP BY
  g.id;
$$;

DROP FUNCTION IF EXISTS public.get_groups;
CREATE OR REPLACE FUNCTION public.get_groups()
RETURNS table(
  groups json,
  slots json[]
)
LANGUAGE sql
AS $$
SELECT
  to_json(g) as group,
  array_agg(to_json(s)) as slots
FROM
  public.groups as g
  INNER JOIN public.reservation_slots s ON g.id = s.group_id
GROUP BY
  g.id;
$$;

DROP FUNCTION IF EXISTS public.join_reservation;
CREATE OR REPLACE FUNCTION public.join_reservation(_slot_id UUID)
RETURNS BOOL
LANGUAGE plpgsql
AS $$
BEGIN
-- check if slot exists
IF NOT EXISTS(
  SELECT 1
  FROM public.reservation_slots
  WHERE id = _slot_id
) THEN
  RAISE EXCEPTION 'Slot not found';
END IF;

-- check if slot is not full
IF NOT EXISTS(
  SELECT 1
  FROM public.reservations
  WHERE slot_id = _slot_id
  GROUP BY slot_id
  HAVING count(*) < max_count
) THEN
  RAISE EXCEPTION 'Slot is full';
END IF;

-- check if user already joined
IF EXISTS(
  SELECT 1
  FROM public.reservations
  WHERE slot_id = _slot_id AND user_id = auth.uid()
) THEN
  RAISE EXCEPTION 'Already joined';
END IF;

-- insert
INSERT INTO public.reservations (user_id, slot_id)
VALUES (auth.uid(), _slot_id);

RETURN true;
END;
$$;
