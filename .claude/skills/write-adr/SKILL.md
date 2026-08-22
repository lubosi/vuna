---
name: write-adr
description: Use when a decision is being made that changes scope, stack, or one of the four architectural decisions in CLAUDE.md (accounts, catalogue, WhatsApp Cloud API, maps). Fires on "let's add accounts after all" or "should we use the Cloud API now" as much as on explicit "write an ADR" requests.
allowed-tools: Read, Grep, Glob, Edit, Write
---

## Procedure
1. Read @docs/decisions/_template.md and the existing ADRs in `docs/decisions/` to find the next number.
2. Create `docs/decisions/NNNN-kebab-case-title.md` from the template.
3. Fill Context (why this is being decided now), Decision (one plain sentence), Consequences (what gets easier/harder/foreclosed), and Revisit when (a concrete trigger, not "if it becomes a problem").
4. If this ADR reverses one of the four architectural decisions in CLAUDE.md, say so explicitly in Context and update CLAUDE.md's decision list to point at the new ADR.
5. Link the new ADR from `docs/README.md`.

## Before reporting done
- [ ] Correct next number used, no collision
- [ ] All four sections filled, Revisit-when is a concrete trigger
- [ ] CLAUDE.md updated if this reverses one of the four decisions
- [ ] Linked from docs/README.md
