---
name: new-migration
description: Use for any schema change — a new table, column, index, constraint, or RLS policy — anywhere under supabase/migrations/. Fires on requests like "add a column for X" or "we need an index on Y" as much as on requests that name "migration" explicitly.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash(pnpm supabase:*), Bash(pnpm gen:types:*)
---

Follow @docs/data-model.md for the six-table schema and its invariants, and the path-scoped rule at .claude/rules/migrations.md.

## Procedure
1. Create a timestamped migration file under `supabase/migrations/`.
2. State forward intent in a leading comment, and rollback intent (or why it's not reversible) alongside it.
3. Include the RLS policy for any new or changed table/column in this same migration — never defer it.
4. Add an index for any new column used as a filter path (browse screen, ops queue) — check @docs/data-model.md for the indexes already expected.
5. If the change touches `listings.unit`, `listings.moq`, `quote_requests`, or phone number columns, re-state in the migration comment which invariant from @docs/data-model.md it must not break.
6. Apply to the target Supabase project and regenerate TypeScript types.
7. If this is a destructive change to `quote_requests` (drop, hard delete path, data loss), stop and ask — that table must never lose a row.

## Before reporting done
- [ ] Migration is timestamped and under `supabase/migrations/`
- [ ] RLS policy included in the same migration
- [ ] Index added for every new filter path
- [ ] Relevant invariant(s) from @docs/data-model.md restated in the migration comment
- [ ] Types regenerated
- [ ] No destructive change to `quote_requests` without explicit confirmation
