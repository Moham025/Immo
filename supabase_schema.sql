-- Table des parcelles et maisons (Biens immobiliers)
create table public.parcelles (
  id            uuid primary key default gen_random_uuid(),
  created_at    timestamptz default now(),
  titre         text not null,
  categorie     text default 'parcelle',  -- 'parcelle' | 'maison'
  quartier      text,
  ville         text,
  superficie    numeric,                  -- en m²
  prix          numeric,                  -- en FCFA
  type_document text,                     -- 'titre foncier' | 'PUH' | 'attestation' | 'autre'
  description   text,
  statut        text default 'disponible',-- 'disponible' | 'reserve' | 'vendu'
  images        text[] default '{}',      -- liste d'URLs publiques (Storage)
  telephone     text,                     -- optionnel (sinon numéro global de l'app)
  whatsapp      text,                     -- optionnel
  featured      boolean default false     -- pour mettre en avant dans le carrousel
);

-- Sécurité
alter table public.parcelles enable row level security;

-- Lecture publique (le site est public)
create policy "Lecture publique des parcelles"
  on public.parcelles
  for select
  to anon
  using (true);

-- AUCUNE policy insert/update/delete pour anon  →  écriture impossible depuis le site.
-- On ajoute / modifie les parcelles et maisons depuis le Dashboard (Table Editor).
