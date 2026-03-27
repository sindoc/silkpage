# core+

`core+` is the additive governance and transformation extension layer for SilkPage.

It sits next to `core/` on purpose:
- `core/` remains the canonical engine and established runtime assets
- `core+/` carries new model packs, governance mappings, and experimental-but-structured extensions

The persona governance scenario pack lives here because it is:
- transformation-heavy
- XML-first
- aligned with Atom, RSS, SKOS, and Collibra payload publication
- intended to evolve without destabilizing the existing `core/` tree

Current contents:
- `model/persona-governance-scenario-spec.xml`
- `model/persona-governance-updates.atom.xml`
- `model/persona-governance-updates.rss.xml`
- `model/persona-governance-concepts.skos.rdf`
