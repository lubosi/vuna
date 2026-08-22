# 0005 - Canonical unit per product

## Status
Accepted

## Context
If unit were a per-listing field, two sellers of the same product could list in different units, making prices impossible to compare without a conversion step — and conversion introduces rounding disputes and trust problems in a market where price comparability is the product.

## Decision
Each catalogue product owns exactly one canonical unit for its lifetime (`kg`, `tonne`, `litre`, or `stem`), set when the product is added (@docs/catalogue-spec.md) and enforced at the database level so `listings.unit` can never diverge from it (@docs/data-model.md).

## Consequences
A product that's genuinely sold in two units in the real market (e.g. eggs by tray or by count) has to pick one, which occasionally won't match how one particular seller thinks about their stock. In exchange, every listing for a product is directly price-comparable with no conversion step.

## Revisit when
A specific product's single-unit assumption breaks down often enough in ops review to be a recurring friction point — track it as a catalogue note before reopening.
