# 0001 - No accounts in v1

## Status
Accepted

## Context
Building seller and buyer accounts (auth, sessions, password or OTP flows) is real engineering effort that doesn't test the MVP question: will real buyers and sellers transact through us in one corridor? Account infrastructure is only worth building once we know the answer is yes.

## Decision
No user accounts in v1. Sellers submit a listing with a phone number; it lands in `pending_review`; ops verifies by WhatsApp out of band. Sellers edit their own listing via a tokenised link (`sellers.edit_token`), not a login. Only `/ops` is gated, by a single shared password.

## Consequences
Faster to build, nothing to migrate later beyond adding real auth on top of existing `sellers`/`listings` rows. Makes it easier to spoof a submission (mitigated by ops verification) and means there's no seller-facing history/dashboard — sellers rely on ops and WhatsApp for status.

## Revisit when
Manual ops verification volume becomes the bottleneck (@docs/roadmap.md P6), or sellers start asking for their own login in volume.
