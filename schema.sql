-- Run in Supabase SQL Editor. Authentication is email/password.
-- All signed-in users can share the same church library and setlists.
create table if not exists public.songs (
  id uuid primary key default gen_random_uuid(),
  title text not null unique,
  created_at timestamptz not null default now(),
  constraint title_not_blank check (length(trim(title)) > 0)
);
create table if not exists public.setlists (
  id uuid primary key default gen_random_uuid(),
  set_date date not null,
  created_at timestamptz not null default now()
);
create table if not exists public.setlist_songs (
  setlist_id uuid not null references public.setlists(id) on delete cascade,
  song_id uuid not null references public.songs(id) on delete restrict,
  position integer not null check (position >= 0 and position <= 4),
  primary key (setlist_id, song_id),
  unique (setlist_id, position)
);
create index if not exists idx_setlists_date on public.setlists(set_date desc);
create index if not exists idx_setlist_songs_song on public.setlist_songs(song_id);
alter table public.songs enable row level security;
alter table public.setlists enable row level security;
alter table public.setlist_songs enable row level security;
create policy "Authenticated members manage songs" on public.songs for all to authenticated using (true) with check (true);
create policy "Authenticated members manage setlists" on public.setlists for all to authenticated using (true) with check (true);
create policy "Authenticated members manage setlist songs" on public.setlist_songs for all to authenticated using (true) with check (true);
