---
name: add-catalogue-product
description: Use when someone wants to add a new product, crop, cut, or flower to the catalogue so sellers can list it — including requests like "sellers keep asking for X" or "add tomatoes as a new listing option." Also fires when a seller submission was rejected for not having a matching catalogue product.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(pnpm supabase:*), Bash(pnpm gen:types:*)
---

Follow @docs/catalogue-spec.md for the rules this procedure enforces.

## Procedure
1. Search existing `products.aliases` and `products.name` (via the seed file and/or a live query) for anything that could already cover this product under a different name. If found, stop and tell the caller which existing product covers it — do not create a duplicate.
2. Confirm the category (`fresh_produce` | `meat_poultry` | `dairy` | `flowers`).
3. Pick the canonical unit per the rules in @docs/catalogue-spec.md and state the justification in the migration comment.
4. Gather aliases: English synonyms plus at least one local-language term where one plausibly exists for this corridor. Ask the caller if you don't know one — don't invent a term you're not confident is real.
5. Set the grade vocabulary from the category defaults in @docs/catalogue-spec.md, or ask before deviating.
6. Use the `new-migration` skill to write the migration (insert into `products`) and update `supabase/seed.sql`.
7. Regenerate TypeScript types.
8. Leave `is_active = false` (or note explicitly that ops must flip it) — a new product needs ops review before sellers can pick it.

## Before reporting done
- [ ] Confirmed this isn't a duplicate under a different name/alias
- [ ] Category, canonical unit (with justification), and grades are set
- [ ] At least one local-language alias gathered or explicitly asked for
- [ ] Migration written via `new-migration`, seed updated, types regenerated
- [ ] Ops-review flag noted
