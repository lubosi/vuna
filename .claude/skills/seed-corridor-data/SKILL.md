---
name: seed-corridor-data
description: Use when realistic demo or test data is needed for the launch corridor — sellers, listings, or RFQs for local dev, staging, or a demo. Not for production data entry, which goes through the real listing/RFQ flow.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(pnpm supabase:*)
---

Follow @docs/data-model.md for schema and invariants, and @docs/product-brief.md for the corridor (Lusaka peri-urban growing areas → Lusaka, Zambia).

## Procedure
1. Confirm the target is a local or non-production Supabase project — check the project ref/URL against what's configured for production before writing anything. If unsure, stop and ask.
2. Generate sellers using only real region names from the `regions` seed table.
3. Generate listings using only catalogue `products` (never an invented product name), with `unit` inherited from the product and prices in a believable ZMW band for that product/category.
4. Enforce `moq <= qty_available` on every generated listing.
5. Generate RFQs against a subset of listings with plausible `qty_wanted` and a mix of statuses across the funnel (`new`, `seller_notified`, `responded`, `agreed`, `dead`) so the ops queue and metrics views have something to show.
6. Use plausible but clearly fake names/phone numbers (not real people's numbers) in non-production data.

## Before reporting done
- [ ] Confirmed target is not production
- [ ] All products/regions reference real catalogue/seed rows, nothing invented
- [ ] `moq <= qty_available` holds on every generated listing
- [ ] RFQ statuses cover a realistic spread of the funnel
- [ ] No real personal phone numbers used
