---
name: new-screen
description: Use when adding a new user-facing route or substantially changing an existing one — buyer browse/detail/RFQ, seller listing form, or /ops screens. Not for a pure copy tweak or a backend-only change with no UI.
allowed-tools: Read, Grep, Glob, Edit, Write
---

Follow @docs/design-system.md and @docs/architecture.md, and the path-scoped rule at .claude/rules/app.md.

## Procedure
1. Default to a server component. Only reach for a client component with a stated reason (browser state, event handler, browser API, third-party client SDK).
2. Use design tokens only (CSS custom properties from @docs/design-system.md) — no ad-hoc colours or spacing.
3. Ensure every interactive element meets the 44px minimum tap target.
4. Build all four states: loading, empty, error, and the happy path — not just the happy path.
5. Make form fields keyboard-appropriate: correct `inputmode` and `autocomplete` per @docs/design-system.md.
6. Route any image input through the client-side compression pipeline in `lib/images/` before it reaches Storage.
7. Add a PostHog event on the key action this screen exists for (submit listing, submit RFQ, approve listing, etc.).
8. Run the `mobile-ux-critic` agent against the finished screen.

## Before reporting done
- [ ] Server component unless a specific reason required client
- [ ] Design tokens only, no ad-hoc styling values
- [ ] 44px minimum tap targets
- [ ] Loading, empty, and error states all present
- [ ] Form fields keyboard-appropriate
- [ ] Images go through the compression pipeline
- [ ] PostHog event added on the key action
- [ ] `mobile-ux-critic` review run and its findings addressed or explicitly deferred
