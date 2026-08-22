# Design System

## Palette
Earth-and-growth palette, not a stock "agriculture green" cliché — warm neutral base with a deep clay-green primary and a marigold accent for calls to action (RFQ, submit listing). Defined as CSS custom properties in `app/globals.css`:

```css
:root {
  --color-bg: #FBF8F3;
  --color-surface: #FFFFFF;
  --color-text: #2A2620;
  --color-text-muted: #6B6355;
  --color-primary: #35533F;       /* deep clay-green — primary actions, links */
  --color-primary-hover: #2A4232;
  --color-accent: #D98E2B;        /* marigold — RFQ / submit CTAs */
  --color-border: #E4DDD0;
  --color-danger: #B3423A;
  --color-success: #3C7A4E;

  --radius-sm: 6px;
  --radius-md: 10px;
  --radius-lg: 16px;

  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
}
```

Dark mode is not in scope for v1 — ops and sellers use this outdoors on cheap Android screens where a light, high-contrast surface reads better than dark UI.

## Type scale
| Token | Size | Use |
|---|---|---|
| `--text-xs` | 12px | metadata, timestamps |
| `--text-sm` | 14px | body, form labels |
| `--text-base` | 16px | primary body — never smaller as a base, to avoid iOS input zoom |
| `--text-lg` | 20px | section headers |
| `--text-xl` | 28px | page titles |

System font stack — no webfont download on a 3G first load.

## Breakpoints (mobile-first)
Design and build for 360px width first; every other breakpoint is a progressive enhancement, not a redesign.
| Breakpoint | Width | Notes |
|---|---|---|
| base | 360px+ | the only breakpoint that matters for launch |
| `sm` | 640px | minor spacing increases |
| `md` | 768px | `/ops` console can use a two-column layout here |
| `lg` | 1024px | `/ops` desktop layout |

## Tap targets
Minimum 44×44px for any interactive element — buttons, form controls, links in a list. Verify with the `mobile-ux-critic` agent, not by eye.

## Performance budget
- First Contentful Paint < 2.5s on throttled Fast 3G, mid-tier Android.
- JS shipped to the seller-facing listing form < 150KB gzipped.
- No layout shift from late-loading images — always set width/height or an aspect-ratio box.
- Images compressed client-side before upload (@docs/architecture.md).

## Form-field conventions
- `inputmode="numeric"` for quantity/price/MOQ fields; `inputmode="tel"` for phone.
- `autocomplete="tel"` on phone fields, `autocomplete="name"` on name fields.
- One field per screen-width row on mobile — no side-by-side fields under 640px.
- Every field has a visible label, not a placeholder-as-label.
- Validation errors appear inline, next to the field, on blur — not only on submit.
