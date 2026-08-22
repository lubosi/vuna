# Product Brief

## What Vuna is
A B2B-first marketplace where African farmers and producers list commodities for sale and buyers request quotes. Positioned as the Alibaba/Pinduoduo of African agriculture — bulk trade between producers and buying businesses, not a consumer grocery app. B2C traffic is tolerated if it shows up; nothing is designed for it.

## Who it serves
- **Sellers**: farmers, producer groups, and small aggregators in the Lusaka peri-urban growing areas who have volume to move and a phone number, but no digital storefront today.
- **Buyers**: restaurants, hotels, retailers, and other businesses in Lusaka sourcing fresh produce, meat & poultry, dairy, or flowers in bulk.

## The MVP question
Will real buyers and real sellers transact through us in one corridor? That's the only thing the MVP is built to test. Every feature decision should be judged against whether it moves us closer to answering that question, not against what a "real" marketplace eventually needs.

## The commercial model
- Sellers set a **MOQ** (minimum order quantity) per listing, in the product's canonical unit.
- Buyers submit an **RFQ** (request for quote) against a listing.
- Quotes are negotiated and agreed **over WhatsApp**, not in the app.
- Payment and delivery happen **off platform** in v1.

Vuna's job in v1 is discovery and introduction, not transaction processing.

## Categories at launch
Fresh produce (vegetables, fruit), Meat & poultry, Dairy, Flowers.
Canonical units: `kg`, `tonne`, `litre`, `stem`.

## Launch corridor
Lusaka peri-urban growing areas → Lusaka city buyers, Zambia. Currency ZMW. Phone numbers E.164, country code +260.

## Success metrics
- Median time to first listing < 90s
- \> 70% of listings approved with no ops edit
- Median seller RFQ response < 4h
- \> 15% of RFQs reach an agreed quote

These are the numbers that decide whether we build P6 (automation) or go back to the drawing board on the corridor.

## Out of scope for v1
Payments/escrow · logistics & delivery · seller or buyer accounts · in-app chat · ratings & reviews · seller analytics dashboard · maps/geocoding · multi-language UI (aliases in search only) · native mobile app · WhatsApp Cloud API.

If a request looks like it's building toward one of these, use the `scope-guard` skill before writing code.

## Related
@docs/roadmap.md for how we get there in phases.
@docs/decisions/ for why the four constraints below exist.
