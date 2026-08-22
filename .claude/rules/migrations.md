---
paths:
  - "supabase/migrations/**"
---

# Migration rules

- Every schema change is a migration file, timestamped, forward-only in application (rollback intent noted in a comment, not a separate down-migration unless the CLI requires one).
- RLS policy ships in the *same* migration as the table/column it protects — never a follow-up migration.
- Any new column used as a filter (browse screen, ops queue) gets an index in the same migration.
- `listings.unit` must be enforced to equal `products.canonical_unit` at the DB level (trigger or generated column), not left to app code.
- Never hand-edit schema in Supabase Studio — if it's not a migration file, it didn't happen.
- Regenerate TypeScript types after applying.
- State which invariant(s) from @docs/data-model.md the change must not break, in the migration file's leading comment.
