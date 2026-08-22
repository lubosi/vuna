# Roadmap

Seven phases, each with an entry condition (what must be true to start) and an exit criterion (what must be true to move on). Don't start a phase whose entry condition isn't met, and don't call a phase done without meeting its exit criterion.

## P0 — Foundations
**Entry**: nothing — this is where we start.
**Do**: repo, Next.js scaffold, CI, Vercel preview deploys, this documentation set.
**Exit**: a green CI pipeline on an empty app, preview deploys working, docs reviewed.

## P1 — Catalogue & schema
**Entry**: P0 exit met.
**Do**: research and seed the product catalogue (~80–120 products, @docs/catalogue-spec.md), write the six tables as migrations (@docs/data-model.md) with RLS, set up the Storage bucket, regenerate TypeScript types.
**Exit**: a fresh cloud Supabase project applies all migrations cleanly; catalogue seed loads; types compile.

## P2 — Listing flow
**Entry**: P1 exit met.
**Do**: the seller listing form — sub-60-second target, catalogue picker, MOQ, photos through the compression pipeline.
**Exit**: `mobile-ux-critic` review passes; a real listing survives end-to-end on a throttled-3G test device.

## P3 — Buyer browse & RFQ
**Entry**: P2 exit met.
**Do**: buyer browse, filters, listing detail, RFQ form → `wa.me` seller notify.
**Exit**: a full loop — browse → detail → RFQ → seller gets a WhatsApp message — works on a real phone.

## P4 — Ops console
**Entry**: P3 exit met.
**Do**: minimal `/ops`: password gate, pending-review queue, listing approve/edit, RFQ queue and status moves.
**Exit**: ops can run the full @docs/ops-runbook.md loop without touching Supabase Studio.

## P5 — Launch the corridor
**Entry**: P4 exit met.
**Do**: seed real listings (`seed-corridor-data` for demo/test data, real sellers for launch), perf pass against the budget in @docs/design-system.md, go live in Lusaka.
**Exit**: real sellers and real buyers are transacting; success metrics (@docs/product-brief.md) are being measured weekly.

## P6 — Automate only what hurts
**Entry**: P5 running for long enough to know what actually hurts (manual relay volume, seller account requests, etc.) — not before.
**Do**: whichever of Cloud API migration, seller accounts, or quote threads the data says is the bottleneck. Each requires an ADR (`write-adr` skill) since each reverses one of the four architectural decisions.
**Exit**: n/a — this phase is ongoing, one ADR-backed change at a time.
