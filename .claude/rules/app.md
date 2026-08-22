---
paths:
  - "app/**"
---

# App route rules

- Server components by default; a client component needs a stated reason (browser state, event handler, browser API, third-party client SDK).
- Design tokens only (@docs/design-system.md CSS custom properties) — no ad-hoc hex colours or magic spacing values.
- 44×44px minimum tap targets on every interactive element.
- Every route handles loading, empty, and error states — not just the happy path.
- Form fields use the correct `inputmode`/`autocomplete` (@docs/design-system.md).
- Mobile-first: build and test at 360px before any wider breakpoint.
- Photo inputs go through the client-side compression pipeline in `lib/images/` (@docs/architecture.md) — never upload an uncompressed file.
