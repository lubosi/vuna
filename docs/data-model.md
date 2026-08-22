# Data Model

Six tables. Nothing else in v1 — if a feature needs a seventh table, it's probably out of scope; check `scope-guard` first.

## categories
| Column | Notes |
|---|---|
| id | PK |
| slug | `fresh_produce` \| `meat_poultry` \| `dairy` \| `flowers` |
| name | display label |
| sort_order | controls browse ordering |

**RLS**: public read (`anon` and `authenticated` select). No client write path — categories are seeded via migration only.
**Indexes**: none beyond PK; four rows, always fetched in full.

## products
| Column | Notes |
|---|---|
| id | PK |
| category_id | FK → categories |
| name | canonical display name, ops-curated |
| canonical_unit | `'kg' \| 'tonne' \| 'litre' \| 'stem'` — owned by the product, never by the listing |
| aliases | `text[]`, local-language search terms, e.g. `'sukuma wiki','collard greens','kale'` |
| grades | `text[]`, e.g. `'Grade A','Grade B','Export'` |
| image_url | catalogue photo, not a seller photo |
| is_active | soft-disable without deleting history |

**RLS**: public read for `is_active = true`. Writes only via migration/seed or the `/ops` service role — no anon insert/update path.
**Indexes**: GIN on `aliases` for search; btree on `category_id` for browse filtering.

## sellers
| Column | Notes |
|---|---|
| id | PK |
| display_name | shown to buyers |
| phone_e164 | **E.164 only, never as typed** — normalise on write |
| whatsapp_ok | seller confirmed this number takes WhatsApp |
| region_id | FK → regions |
| verified_at / verified_by | set by ops after out-of-band WhatsApp verification |
| edit_token | opaque token for the seller's tokenised edit link — treat as a secret, never log it |
| notes | ops-only free text |

**RLS**: no public select (phone numbers are PII). `/ops` service role reads/writes everything. A seller's own edit link authenticates by possession of `edit_token`, checked in a server action, not via RLS-visible session.
**Indexes**: btree on `phone_e164` (dedupe on submit), btree on `region_id`.

## listings
| Column | Notes |
|---|---|
| id | PK |
| seller_id | FK → sellers |
| product_id | FK → products |
| grade | must be one of `products.grades` for this product |
| qty_available | numeric, in `unit` |
| unit | **inherited from `products.canonical_unit`, not editable** — enforce with a trigger or generated column, not just app code |
| price_per_unit | numeric |
| currency | ZMW at launch |
| moq | seller-defined, same unit as `qty_available`; **`moq <= qty_available`** |
| available_from / available_to | date range the listing is valid |
| region_id | FK → regions, pickup location |
| pickup_note | free text, e.g. gate code or landmark |
| photos | `text[]`, seller-uploaded, via the compression pipeline (@docs/architecture.md) |
| status | `'pending_review' \| 'live' \| 'paused' \| 'expired'` |
| created_at / reviewed_at / expires_at | lifecycle timestamps |

**RLS**: public read where `status = 'live'`. Insert allowed from the public listing form (lands as `pending_review`). Update restricted to the `/ops` service role, except the seller's own tokenised edit path.
**Indexes**: btree on `(status, category via product_id)`, btree on `region_id`, btree on `product_id` — these back the browse/filter screen. Composite `(status, product_id, region_id)` if browse filters combine all three.

## quote_requests
| Column | Notes |
|---|---|
| id | PK |
| listing_id | FK → listings |
| buyer_name / buyer_company | free text |
| buyer_phone_e164 | **E.164 only** |
| qty_wanted | numeric, in the listing's unit |
| delivery_region_id | FK → regions |
| message | buyer's free-text note |
| status | `'new' \| 'seller_notified' \| 'responded' \| 'agreed' \| 'dead'` |
| created_at / first_response_at / closed_at | funnel timestamps — these drive the success metrics in @docs/product-brief.md |
| outcome_note | ops-logged, from the runbook |

**This table is the experiment's primary dataset — never lose a row, never hard-delete.** No RLS delete policy for any role except a service-role migration correcting bad data.
**RLS**: insert allowed from the public RFQ form. No public select (buyer PII). `/ops` service role has full read/update.
**Indexes**: btree on `listing_id`, btree on `status` (ops queue), btree on `created_at` (metrics).

## regions
| Column | Notes |
|---|---|
| id | PK |
| name | e.g. "Lusaka", "Chongwe" |
| type | `'growing' \| 'market'` |
| parent_id | self-FK for nesting (e.g. a ward under Lusaka) |

**RLS**: public read. Seeded via migration, no client write path.
**Indexes**: btree on `parent_id`.

## Invariants — restate wherever relevant
1. `listings.unit` always equals `products.canonical_unit`. Enforce in the DB (trigger or generated column), not just the UI.
2. `listings.moq <= listings.qty_available`, same unit.
3. Phone numbers are stored E.164 only, never as typed. Normalise before insert.
4. `quote_requests` is append-mostly: status/outcome updates only, never a hard delete.
