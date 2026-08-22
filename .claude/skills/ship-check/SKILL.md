---
name: ship-check
description: Use before opening a PR, or whenever asked if something is ready to ship. Runs the full verification pass and reports pass/fail — it does not silently fix problems it finds.
allowed-tools: Bash(pnpm typecheck:*), Bash(pnpm lint:*), Bash(pnpm test:*), Bash(pnpm build:*), Read, Grep, Glob
---

## Procedure
1. Run typecheck.
2. Run lint.
3. Run unit tests.
4. Run the production build.
5. Do a 360px-viewport pass on any changed screen (resize/emulate, check for overflow, unreadable text, or broken tap targets).
6. Do a quick accessibility pass on any changed screen (labels present, contrast plausible, focus order sane).
7. Report a pass/fail table, one row per check, and stop.

## Before reporting done
- [ ] Typecheck, lint, unit tests, and build results all reported, pass or fail
- [ ] 360px-viewport pass done on changed screens
- [ ] Quick a11y pass done on changed screens
- [ ] Reported as a pass/fail table — no silent auto-fixing of failures
