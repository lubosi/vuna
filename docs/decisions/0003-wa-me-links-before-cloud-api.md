# 0003 - wa.me links before Cloud API

## Status
Accepted

## Context
The WhatsApp Business Cloud API needs Meta Business verification, templated message approval, and ongoing per-message cost — real overhead before we know whether the corridor works at all. `wa.me` deep links need none of that and get us the same core loop: one tap opens a pre-filled WhatsApp chat.

## Decision
v1 reaches WhatsApp exclusively via `wa.me` deep links (@docs/whatsapp.md). No Meta Cloud API calls. All link-building goes through one seam (`lib/whatsapp/`) designed so Cloud API can replace it later without touching call sites.

## Consequences
No delivery guarantees, no read receipts, no automation of the relay — ops manually confirms messages sent (@docs/ops-runbook.md). In exchange, zero setup cost and zero per-message cost during the corridor test.

## Revisit when
Manual relay volume becomes the ops bottleneck (@docs/roadmap.md P6), or we need delivery confirmation/read receipts to trust the RFQ funnel metrics.
