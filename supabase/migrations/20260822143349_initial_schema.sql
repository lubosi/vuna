-- Initial schema: the six tables in docs/data-model.md.
-- Invariants this migration enforces at the DB level (docs/data-model.md):
--   1. listings.unit always equals products.canonical_unit (sync_listing_unit trigger).
--   2. listings.moq <= listings.qty_available (check constraint).
--   3. Phone numbers are stored E.164 only (check constraint on phone_e164 columns).
--   4. quote_requests is append-mostly: no delete policy is granted to any
--      client role, and there is no ON DELETE CASCADE into it.

create extension if not exists pgcrypto;

-- categories -----------------------------------------------------------

create table categories (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug in ('fresh_produce', 'meat_poultry', 'dairy', 'flowers')),
  name text not null,
  sort_order int not null default 0
);

alter table categories enable row level security;

create policy "categories are publicly readable"
  on categories for select
  to anon, authenticated
  using (true);

-- products ---------------------------------------------------------------

create table products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references categories(id),
  name text not null,
  canonical_unit text not null check (canonical_unit in ('kg', 'tonne', 'litre', 'stem')),
  aliases text[] not null default '{}',
  grades text[] not null default '{}',
  image_url text,
  is_active boolean not null default false
);

create index products_category_id_idx on products(category_id);
create index products_aliases_gin_idx on products using gin(aliases);

alter table products enable row level security;

create policy "active products are publicly readable"
  on products for select
  to anon, authenticated
  using (is_active = true);

-- regions ------------------------------------------------------------------

create table regions (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text not null check (type in ('growing', 'market')),
  parent_id uuid references regions(id)
);

create index regions_parent_id_idx on regions(parent_id);

alter table regions enable row level security;

create policy "regions are publicly readable"
  on regions for select
  to anon, authenticated
  using (true);

-- sellers --------------------------------------------------------------

create table sellers (
  id uuid primary key default gen_random_uuid(),
  display_name text not null,
  phone_e164 text not null check (phone_e164 ~ '^\+[1-9]\d{6,14}$'),
  whatsapp_ok boolean not null default false,
  region_id uuid not null references regions(id),
  verified_at timestamptz,
  verified_by text,
  edit_token uuid not null default gen_random_uuid(),
  notes text,
  created_at timestamptz not null default now()
);

create index sellers_phone_e164_idx on sellers(phone_e164);
create index sellers_region_id_idx on sellers(region_id);
create unique index sellers_edit_token_idx on sellers(edit_token);

alter table sellers enable row level security;

-- Sellers can be created by the public listing form. Phone numbers are PII,
-- so no select/update/delete policy is granted here — ops and the seller's
-- own tokenised edit link both go through the service role in a server
-- action (docs/data-model.md).
create policy "anyone can submit a new seller"
  on sellers for insert
  to anon, authenticated
  with check (true);

-- listings -------------------------------------------------------------

create table listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid not null references sellers(id),
  product_id uuid not null references products(id),
  grade text not null,
  qty_available numeric not null check (qty_available > 0),
  unit text not null check (unit in ('kg', 'tonne', 'litre', 'stem')),
  price_per_unit numeric not null check (price_per_unit > 0),
  currency text not null default 'ZMW',
  moq numeric not null check (moq > 0),
  available_from date,
  available_to date,
  region_id uuid not null references regions(id),
  pickup_note text,
  photos text[] not null default '{}',
  status text not null default 'pending_review'
    check (status in ('pending_review', 'live', 'paused', 'expired')),
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  expires_at timestamptz,
  constraint moq_within_qty_available check (moq <= qty_available)
);

create index listings_status_product_id_idx on listings(status, product_id);
create index listings_region_id_idx on listings(region_id);
create index listings_product_id_idx on listings(product_id);

-- Enforce that a listing's unit always matches its product's canonical
-- unit — the seller cannot change it (docs/decisions/0005-canonical-unit-per-product.md).
create function sync_listing_unit()
returns trigger
language plpgsql
as $$
begin
  select canonical_unit into strict new.unit
  from products
  where id = new.product_id;
  return new;
end;
$$;

create trigger listings_sync_unit
  before insert or update of product_id on listings
  for each row
  execute function sync_listing_unit();

alter table listings enable row level security;

create policy "live listings are publicly readable"
  on listings for select
  to anon, authenticated
  using (status = 'live');

create policy "anyone can submit a listing as pending review"
  on listings for insert
  to anon, authenticated
  with check (status = 'pending_review');

-- quote_requests ---------------------------------------------------------

create table quote_requests (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references listings(id),
  buyer_name text not null,
  buyer_company text,
  buyer_phone_e164 text not null check (buyer_phone_e164 ~ '^\+[1-9]\d{6,14}$'),
  qty_wanted numeric not null check (qty_wanted > 0),
  delivery_region_id uuid not null references regions(id),
  message text,
  status text not null default 'new'
    check (status in ('new', 'seller_notified', 'responded', 'agreed', 'dead')),
  created_at timestamptz not null default now(),
  first_response_at timestamptz,
  closed_at timestamptz,
  outcome_note text
);

create index quote_requests_listing_id_idx on quote_requests(listing_id);
create index quote_requests_status_idx on quote_requests(status);
create index quote_requests_created_at_idx on quote_requests(created_at);

alter table quote_requests enable row level security;

-- This table is the experiment's primary dataset — never lose a row.
-- No delete policy is granted to any client role, and the buyer PII in
-- it is never publicly selectable.
create policy "anyone can submit an rfq"
  on quote_requests for insert
  to anon, authenticated
  with check (true);
