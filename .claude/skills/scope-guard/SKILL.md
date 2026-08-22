---
name: scope-guard
description: Use when a request looks like it's building toward something on the v1 out-of-scope list — payments, logistics, seller/buyer accounts, in-app chat, ratings, seller analytics, maps, multi-language UI, native mobile, or WhatsApp Cloud API. Fires before writing code for any of these, even if the request doesn't name them directly.
allowed-tools: Read, Grep, Glob
---

## Procedure
1. Compare the request against the out-of-scope list in @docs/product-brief.md.
2. If it's in scope, say so and proceed normally — this skill is a gate, not a blanket refusal.
3. If it's out of scope, say so explicitly, name it, and name the manual/off-platform stand-in we use instead (e.g. "payment happens off-platform, WhatsApp-negotiated" or "no maps — use the fixed regions dropdown").
4. Offer to write an ADR (`write-adr` skill) if the caller wants to actually change scope, rather than building it first.
5. Do not write the out-of-scope code and ask afterward.

## Before reporting done
- [ ] Checked against the actual out-of-scope list in docs/product-brief.md, not memory
- [ ] If out of scope: named what it is, named the manual stand-in, offered an ADR
- [ ] No code written for an out-of-scope feature without an ADR
