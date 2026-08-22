# 0002 - Closed product catalogue

## Status
Accepted

## Context
If sellers can type any product name, prices stop being comparable across listings, search and filters degrade, and a future price index becomes impossible. A closed catalogue is what makes the marketplace's core value — comparable, filterable listings — work at all.

## Decision
Sellers pick from a fixed catalogue of ~80–120 ops-curated products (@docs/catalogue-spec.md); they never type a product name. Each product owns its canonical unit, which the seller cannot change.

## Consequences
Every new product needs an ops step (`add-catalogue-product` skill) before a seller can list it — slower onboarding for a genuinely novel product, but it keeps units and naming consistent, which is what makes filters and future pricing tools possible.

## Revisit when
Catalogue-gap rejections (sellers wanting a product that isn't in the list) become frequent enough to slow onboarding meaningfully — track this as an ops metric before reopening.
