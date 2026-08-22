---
name: whatsapp-link
description: Use when building or changing anything that opens WhatsApp — a wa.me link, a message template, or phone number handling for sellers or buyers. Fires on requests like "add a WhatsApp button" or "change the RFQ notify message."
allowed-tools: Read, Grep, Glob, Edit, Write
---

Follow @docs/whatsapp.md — this skill enforces that contract, it doesn't restate it.

## Procedure
1. Normalise the phone number to E.164 (default country code +260) before building any link — never build a link from an as-typed number.
2. URL-encode the message body with `encodeURIComponent`; never hand-build the query string.
3. Use one of the two message templates in `lib/whatsapp/templates.ts` — write a new one there if this is a genuinely new message type, not inline in a component.
4. Keep the rendered message under ~300 characters; truncate any interpolated free-text field (buyer message, seller notes) to ~200 characters.
5. Route the call through `buildWhatsAppLink()` in `lib/whatsapp/` — never construct a `wa.me` URL inline at the call site.
6. Never hardcode a phone number outside config — the ops number comes from `NEXT_PUBLIC_OPS_WHATSAPP_E164`.

## Before reporting done
- [ ] Number normalised to E.164 before use
- [ ] Message URL-encoded via the shared helper, not hand-built
- [ ] Template lives in `lib/whatsapp/templates.ts`, not inline
- [ ] Rendered message stays under the practical length limit
- [ ] No hardcoded phone number outside config
- [ ] Call site goes through `buildWhatsAppLink()`, preserving the Cloud API seam
