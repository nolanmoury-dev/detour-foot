-- À lancer UNE fois dans Supabase > SQL Editor si tu as déjà lancé l'ancien schema.sql.
-- (Nouvelle installation : schema.sql contient déjà tout, ne lance pas ce fichier.)

-- Chat et paris : écriture réservée aux comptes connectés
alter table public.chat add column if not exists user_id uuid default auth.uid();
alter table public.bets add column if not exists user_id uuid default auth.uid();

drop policy if exists "chat: écriture" on public.chat;
create policy "chat: écriture" on public.chat for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "paris: écriture" on public.bets;
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
drop trigger if exists on_auth_user_operator on auth.users;
create trigger on_auth_user_operator after insert on auth.users
  for each row execute function public.make_operator();

-- Si le compte Noln_mry existe déjà, on lui donne les droits tout de suite
insert into public.admins (user_id)
  select id from auth.users where lower(email) = 'noln_mry@gmail.com'
  on conflict do nothing;
