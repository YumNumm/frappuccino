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
  id UUID default uuid_generate_v4() PRIMARY KEY,
  name TEXT,
  email TEXT NOT NULL UNIQUE,
  type user_type,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

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

CREATE TABLE IF NOT EXISTS public.reservations(
  user_id UUID REFERENCES public.profiles(id),
  slot_id UUID REFERENCES public.reservation_slots(id),
  PRIMARY KEY (user_id, slot_id)
);

-- create_profile_for_user function
-- ユーザーが登録されたときに、profilesテーブルにも登録する
-- waiting_usersテーブルにメールアドレスがあれば is_email_verified を true にする
create function public.handle_new_user() returns trigger language plpgsql security definer
set
  search_path = public as $ $ BEGIN
INSERT INTO
  public.profiles (email, type, is_email_verified, name)
SELECT
  NEW.email,
  wu.type,
  true,
  --
  wu.name
FROM
  public.waiting_users wu
WHERE
  wu.email = NEW.email RETURN NEW;

END;

$;

create trigger on_auth_user_created
after
insert
  on auth.users for each row execute procedure public.handle_new_user();