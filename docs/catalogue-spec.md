# Catalogue Spec

The product catalogue is closed and ops-curated (@docs/decisions/0002-closed-product-catalogue.md). Sellers pick from a fixed list; they never type a product name. This doc is the process for maintaining that list — read it before running the `add-catalogue-product` skill.

## Choosing a canonical unit
Every product owns exactly one canonical unit for its whole lifetime (@docs/decisions/0005-canonical-unit-per-product.md). Pick from `kg`, `tonne`, `litre`, `stem` using the unit the corridor actually trades in:
- **kg** — most fresh produce, meat & poultry, small-lot dairy.
- **tonne** — bulk grain-adjacent or high-volume produce where kg would mean unreadable numbers (rare at launch; confirm with ops before using).
- **litre** — liquid dairy (milk).
- **stem** — flowers, sold per stem or bunch-of-stems-normalised.

If a product could plausibly be sold in two units (e.g. eggs by tray vs. by count), pick the one buyers actually quote in this corridor and note the alternative in `pickup_note` conventions, not as a second unit. Never make the unit a per-listing choice — that breaks price comparability, which is the whole point of the catalogue.

## Aliases (local-language search)
`products.aliases` is how buyers find a product without knowing its catalogue name. For each product:
- Include common English synonyms (e.g. "greens").
- Include the Bemba/Nyanja term(s) used in Lusaka markets where one exists.
- Include common misspellings only if they're genuinely common, not speculative.
- Do not include another catalogue product's name as an alias — that's a duplicate, not an alias.

## Grade vocabulary per category
Grades are per-product, drawn from a small controlled vocabulary so the listing form stays a picker, not free text:
- **Fresh produce**: `Grade A`, `Grade B`, `Export`
- **Meat & poultry**: `Grade A`, `Grade B`, `Processed`
- **Dairy**: `Fresh`, `UHT` (only where applicable)
- **Flowers**: `Export`, `Local`

A product's `grades` array should be the smallest set that buyers actually discriminate on — don't add a grade nobody quotes differently.

## Process for adding a product
Use the `add-catalogue-product` skill, which:
1. Confirms the product isn't already covered by an existing product's aliases (duplicate check — this is the most common mistake).
2. Places it in the right category.
3. Picks and justifies the canonical unit per the rules above.
4. Gathers aliases, including at least one local-language term where one exists.
5. Sets the grade vocabulary from the category defaults above, or justifies a deviation.
6. Writes the migration (via `new-migration`) and updates the seed data.
7. Regenerates TypeScript types.
8. Flags the new product for ops review before it's marked `is_active`.

## Catalogue size
~80–120 products at launch. This is a ceiling as much as a floor — a bigger catalogue makes the seller form slower to use and the browse screen harder to filter. Prefer merging near-duplicate products into one entry with more aliases over adding a new row.
