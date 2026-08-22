# WhatsApp Integration

v1 reaches WhatsApp exclusively via `wa.me` deep links (@docs/decisions/0003-wa-me-links-before-cloud-api.md). No Meta Cloud API calls. All of this lives behind `lib/whatsapp/` so the Cloud API can slot in later without touching call sites.

## URL construction
```
https://wa.me/<E164_NO_PLUS>?text=<URL_ENCODED_MESSAGE>
```
- `E164_NO_PLUS`: the phone number in E.164, with the leading `+` stripped (wa.me does not accept it).
- `text`: `encodeURIComponent(message)` — never hand-build the query string.

Build every link through a single `buildWhatsAppLink(phoneE164, message)` helper in `lib/whatsapp/` — this is the seam a Cloud API integration replaces later. Never construct a `wa.me` URL inline in a component.

## E.164 normalisation
- Default country code: `+260` (Zambia) for this corridor.
- Strip spaces, dashes, and parentheses before validating.
- Accept a leading `0` and rewrite it to the country code (`0977123456` → `+260977123456`).
- Reject and ask again on anything that doesn't resolve to a plausible E.164 number — don't silently store a malformed number.
- Store E.164 only (@docs/data-model.md); never store the as-typed string.

## Message templates
Two templates, both in `lib/whatsapp/templates.ts`:

**RFQ notify (to seller)**, triggered when a buyer submits a quote request:
```
New RFQ on Vuna: {buyer_company} wants {qty_wanted} {unit} of {product_name} ({grade}).
Delivery to {delivery_region}. Reply here to quote.
— {buyer_name}, {buyer_phone}
```

**Seller-notify (to ops, listing review)**:
```
New listing pending review: {seller_name} — {product_name}, {qty_available} {unit} @ {price_per_unit} {currency}/{unit}.
Region: {region_name}. Phone: {seller_phone}.
```

Keep the ops WhatsApp number for the second template in `NEXT_PUBLIC_OPS_WHATSAPP_E164`, never hardcoded (@docs/architecture.md).

## Character limits
WhatsApp pre-fill via `wa.me` degrades past roughly 2,000 characters of encoded text on some clients, and long URLs are more likely to be truncated by link-preview scrapers. Keep templates under ~300 characters rendered; never interpolate free-text `message`/`notes` fields in full — truncate to ~200 characters with an ellipsis and note "see listing" or "see RFQ" rather than inlining everything.

## The Cloud API seam
When Cloud API migration happens (P6), `buildWhatsAppLink` and the two templates in `lib/whatsapp/` are the only things that change — call sites (RFQ submit action, ops listing-approve action) stay the same. If you're about to touch WhatsApp behavior anywhere else, that's a sign the seam has leaked; fix the seam, not the call site.
