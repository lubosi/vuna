# Ops Runbook

This is a real operational document — written for the person running ops day to day, not for a future engineer. If a step here doesn't match what the app actually does, fix the app or fix this doc immediately; they must never drift apart.

## Verify a seller
1. A new seller submission arrives (`sellers` row created, first `listings` row at `pending_review`).
2. Message the seller on the phone number they gave, via your own WhatsApp, using the ops number.
3. Confirm: this is really them, the phone takes WhatsApp, and the listing details are plausible (product, quantity, price aren't obviously wrong).
4. In `/ops`, mark the seller verified — this sets `verified_at` and `verified_by`.
5. If the number doesn't respond within a day, leave unverified and follow up once more before letting the listing lapse.

## Approve a listing
1. Open the `/ops` pending-review queue.
2. Check: product and grade match what the seller described, unit matches the catalogue (you can't change this — it's inherited), MOQ ≤ quantity available, price looks plausible for the corridor.
3. If something's off, edit the listing yourself in `/ops` (not in Supabase Studio) or message the seller to correct it.
4. Approve — status moves to `live`. This is the only path a listing becomes publicly visible.
5. If a listing sits unedited and matches the seller's submission exactly, that's a good sign for the "> 70% approved with no edit" metric — don't over-edit for polish.

## Relay an RFQ
1. A buyer submits an RFQ against a live listing (`quote_requests` row, status `new`).
2. The seller gets a WhatsApp notify via `wa.me` (@docs/whatsapp.md) — confirm it actually sent; `wa.me` links open your WhatsApp, they don't send automatically.
3. Mark the RFQ `seller_notified` once you've confirmed the seller has it.
4. If the seller hasn't responded within 4 hours (the target metric), follow up directly.

## Move a status and log an outcome
1. When the seller replies to the buyer, mark the RFQ `responded` and set `first_response_at` if the app hasn't already.
2. Once buyer and seller agree a price/quantity over WhatsApp, mark `agreed`, set `closed_at`, and write a short `outcome_note` (agreed price, quantity, anything worth remembering).
3. If it goes nowhere after a reasonable follow-up window, mark `dead` with a one-line reason in `outcome_note` — "seller unresponsive", "price too high", "buyer went elsewhere". These notes are how we learn what's not working in the corridor.
4. Never delete a `quote_requests` row (@docs/data-model.md) — a dead RFQ is still data.

## Weekly
- Skim `dead` RFQs for a pattern (same product, same reason) — that's a catalogue or pricing signal, not noise.
- Check listings past `expires_at` and follow up with sellers to renew or pause.
