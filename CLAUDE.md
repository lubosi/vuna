# Vuna

B2B-first marketplace connecting African farmers/producers with buyers. MVP question: will real buyers and sellers transact through us in one corridor? Everything else is deferred.

Launch corridor: Lusaka peri-urban growing areas → Lusaka city buyers, Zambia. Currency ZMW. Phone numbers E.164, country code +260.

## Stack
Next.js (App Router) · TypeScript strict · Tailwind · shadcn/ui · Supabase (Postgres + Storage + RLS) · Vercel · PostHog · Sentry. Package manager: pnpm. Mobile-first: assume a low-end Android on throttled 3G.

## The four architectural decisions — do not silently reverse
1. **No user accounts in v1.** No OTP, no passwords, no session auth for sellers or buyers. A seller submits a listing with a phone number; it lands in `pending_review`; ops verifies by WhatsApp out of band. Sellers edit via a tokenised link. Only `/ops` is gated, by a single shared password. See @docs/decisions/0001-no-accounts-in-v1.md.
2. **The product catalogue is closed and ops-curated.** Sellers pick from a fixed list of ~80–120 products; they never type a product name. Each catalogue product owns its canonical unit — the seller cannot change it. See @docs/decisions/0002-closed-product-catalogue.md.
3. **WhatsApp is reached via `wa.me` deep links, not the Cloud API.** No Meta API calls in v1. See @docs/decisions/0003-wa-me-links-before-cloud-api.md.
4. **No maps or geocoding.** Locations are a fixed `regions` table with a dropdown. See @docs/decisions/0004-no-maps-fixed-regions.md.

## House rules
- Never introduce a product name outside the catalogue; add it to the catalogue instead (`add-catalogue-product` skill).
- Never add an auth flow, payment integration, chat feature, map, or Cloud API call without an ADR saying we changed our minds (`write-adr` skill).
- Never let a unit be free text or user-editable — it's inherited from `products.canonical_unit`.
- Every DB change is a migration file; nothing is changed by hand in Studio (`new-migration` skill).
- Mobile-first always: if it doesn't work one-handed on a 360px viewport over 3G, it isn't done.
- Prefer server components; a client component needs a reason.
- Run the ship check (`ship-check` skill) before proposing a PR.
- Out of scope for v1 — check `scope-guard` before building any of it: payments/escrow, logistics & delivery, seller/buyer accounts, in-app chat, ratings & reviews, seller analytics dashboard, maps/geocoding, multi-language UI, native mobile app, WhatsApp Cloud API.

## Documentation
@docs/README.md
@docs/product-brief.md
@docs/data-model.md
@docs/catalogue-spec.md
@docs/architecture.md
@docs/design-system.md
@docs/whatsapp.md
@docs/ops-runbook.md
@docs/roadmap.md
@docs/glossary.md
