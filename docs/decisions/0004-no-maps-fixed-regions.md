# 0004 - No maps, fixed regions

## Status
Accepted

## Context
Geocoding and map UI are engineering and UX overhead that don't matter for a single, well-known corridor — everyone launching in Lusaka already knows the areas by name. A fixed list is faster to build, faster for a seller to use one-handed on a small screen, and good enough for a browse filter.

## Decision
Locations are a fixed `regions` table (`growing` | `market`, self-referencing for nesting) with a dropdown UI. No maps, no geocoding, no lat/long.

## Consequences
Can't do proximity search, distance-based sorting, or delivery-radius logic. Fine for one corridor; would need revisiting for multi-corridor expansion where buyers can't be expected to know every growing area by name.

## Revisit when
We launch a second corridor, or buyers start asking "how far is this from me" often enough that a dropdown can't answer it.
