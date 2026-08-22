-- Starter seed data for local/dev use. This is NOT the full ~80-120 product
-- catalogue (docs/catalogue-spec.md) — it's a small, honest starting set so
-- the app is usable end-to-end. Local-language (Bemba/Nyanja) aliases have
-- deliberately been left off products below rather than guessed; add them
-- via the `add-catalogue-product` skill once verified with someone who
-- actually knows the term, per docs/catalogue-spec.md.

-- categories --------------------------------------------------------------

insert into categories (slug, name, sort_order) values
  ('fresh_produce', 'Fresh Produce', 1),
  ('meat_poultry', 'Meat & Poultry', 2),
  ('dairy', 'Dairy', 3),
  ('flowers', 'Flowers', 4);

-- regions -------------------------------------------------------------
-- Launch corridor: Lusaka peri-urban growing areas -> Lusaka buyers.

insert into regions (name, type, parent_id) values
  ('Lusaka', 'market', null),
  ('Chongwe', 'growing', null),
  ('Chilanga', 'growing', null),
  ('Kafue', 'growing', null);

-- products ----------------------------------------------------------------

with cat as (
  select slug, id from categories
)
insert into products (category_id, name, canonical_unit, aliases, grades, is_active)
select cat.id, p.name, p.canonical_unit, p.aliases, p.grades, true
from (
  values
    ('fresh_produce', 'Tomato', 'kg', array['tomatoes']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Onion', 'kg', array['onions']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Rape', 'kg', array['leafy greens', 'rape leaves']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Cabbage', 'kg', array['cabbages']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Irish Potato', 'kg', array['potato', 'potatoes']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Sweet Potato', 'kg', array['sweet potatoes']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Banana', 'kg', array['bananas']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('fresh_produce', 'Mango', 'kg', array['mangoes', 'mangos']::text[], array['Grade A', 'Grade B', 'Export']::text[]),
    ('meat_poultry', 'Chicken', 'kg', array['broiler', 'road runner']::text[], array['Grade A', 'Grade B', 'Processed']::text[]),
    ('meat_poultry', 'Beef', 'kg', array['beef cuts']::text[], array['Grade A', 'Grade B', 'Processed']::text[]),
    ('meat_poultry', 'Goat Meat', 'kg', array['chevon']::text[], array['Grade A', 'Grade B', 'Processed']::text[]),
    ('dairy', 'Cow Milk', 'litre', array['milk']::text[], array['Fresh', 'UHT']::text[]),
    ('flowers', 'Rose', 'stem', array['roses']::text[], array['Export', 'Local']::text[]),
    ('flowers', 'Carnation', 'stem', array['carnations']::text[], array['Export', 'Local']::text[])
) as p(category_slug, name, canonical_unit, aliases, grades)
join cat on cat.slug = p.category_slug;
