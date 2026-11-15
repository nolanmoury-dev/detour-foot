-- Scoreboard Live : à coller dans Supabase > SQL Editor > Run

create table public.match_state (
  id int primary key default 1 check (id = 1),
  data jsonb not null default '{}',
  updated_at timestamptz not null default now()
);
insert into public.match_state (id, data) values (1,
  '{"h":0,"a":1,"sc":[0,0],"sec":0,"run":0,"sty":"pl","comp":"COUPE DU SERVEUR","logo":"img","fs":"","lt":null,"mus":0,"mute":0,"fx":null}')
on conflict do nothing;

create table public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade
);

create table public.chat (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 30),
  msg text not null check (char_length(msg) between 1 and 120),
  user_id uuid default auth.uid(),
  created_at timestamptz not null default now()
);

create table public.bets (
  id bigint generated always as identity primary key,
  pick smallint not null check (pick between 0 and 2),
  user_id uuid default auth.uid(),
  created_at timestamptz not null default now()
);

alter table public.match_state enable row level security;
alter table public.admins enable row level security;
alter table public.chat enable row level security;
alter table public.bets enable row level security;

-- Tout le monde lit l'état du match, seuls les admins le modifient
create policy "état: lecture" on public.match_state for select using (true);
create policy "état: admin" on public.match_state for update
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));

-- Un compte ne voit que sa propre ligne admin
create policy "admins: soi-même" on public.admins for select using (user_id = auth.uid());

-- Chat et paris : lecture pour tous, écriture réservée aux comptes connectés
create policy "chat: lecture" on public.chat for select using (true);
create policy "chat: écriture" on public.chat for insert to authenticated with check (user_id = auth.uid());
create policy "paris: lecture" on public.bets for select using (true);
create policy "paris: écriture" on public.bets for insert to authenticated with check (user_id = auth.uid());

-- Compte opérateur : le pseudo Noln_mry devient admin dès qu'il est créé sur le site
-- (adresse interne = pseudo + emailDomain de public/config.js, ici gmail.com)
create or replace function public.make_operator() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if lower(new.email) = 'noln_mry@gmail.com' then
    insert into public.admins (user_id) values (new.id) on conflict do nothing;
  end if;
  return new;
end $$;
create trigger on_auth_user_operator after insert on auth.users
  for each row execute function public.make_operator();

-- Temps réel
alter publication supabase_realtime add table public.match_state, public.chat;

-- Stockage des vidéos/musiques (envoi depuis la télécommande, 50 Mo max)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('media', 'media', true, 52428800,
  array['video/mp4','video/webm','audio/mpeg','audio/mp4','audio/wav','audio/ogg','image/png','image/jpeg','image/webp','image/gif'])
on conflict (id) do nothing;

-- Compétitions enregistrées (nom, logo, équipes avec couleurs) : réservé aux admins
create table public.competitions (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 26),
  logo text,
  teams jsonb not null,
  created_at timestamptz not null default now()
);
alter table public.competitions enable row level security;
create policy "compétitions: admin" on public.competitions for all
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));
create policy "media: lecture" on storage.objects for select using (bucket_id = 'media');
create policy "media: admin envoi" on storage.objects for insert
  with check (bucket_id = 'media' and exists (select 1 from public.admins a where a.user_id = auth.uid()));
create policy "media: admin maj" on storage.objects for update
  using (bucket_id = 'media' and exists (select 1 from public.admins a where a.user_id = auth.uid()));
