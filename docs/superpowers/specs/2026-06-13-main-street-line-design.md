# Main Street Line — Design

**Date:** 2026-06-13
**Phase:** slice connective route (Zip's → Spillway)
**Status:** approved, building

## Purpose

Fills the missing slice beat "Main Street line" from the vertical slice flow
(Mercy Hill → Zip's → **Main Street** → Spillway → The Mouth). It is the
connective skate route from the Zip's crew scene down to the Spillway. Uses
only mechanics that already exist — push, brake, ollie, grind, walk, camcorder
— so it adds no new systems and respects the movement-feel gate.

## Wiring (one insertion)

- Mercy Hill currently has a `SceneGate` to `Spillway.tscn` locked behind
  `mission_zips_done`. Repoint that gate to `MainStreet.tscn` (same lock).
- `MainStreet.tscn` ends with a `SceneGate` to `Spillway.tscn`.
- Add a back gate from Main Street to Mercy Hill for traversal/testing.
- Net flow: Mercy Hill ⇄ Zip's → Main Street → Spillway. Nothing else re-routed.

## Layout (graybox, built in code like `mercy_hill.gd`)

Tuned **slow and readable first** per the iteration framework. Gentler slope
angles than Mercy Hill (≈8° / 12° vs 14° / 18°).

- Continuous safe ground line the full length — always a bail-to line.
- Profile: storefront flat → gentle descent → storefront row (flat) → steeper
  drop → Spillway-approach runout.
- **One readable hazard:** a planter/curb to ollie, generous lead time. Bonk at
  speed = bail.
- **One grind line:** a handrail/ledge over the storefront row, snap-to like
  Mercy Hill's rail; missing it drops to the safe line.
- **One branch:** a high awning one-way platform (risky/style line) vs. the safe
  street, rejoining before the Spillway gate. Embodies pillar 2, "kids know the
  real map."

## Story content

One **optional** camcorder beat: a parked **Northstar van** decor prop with an
`EvidenceTarget` ("van plate", evidence id `northstar_plate`). Payoff to June's
"if you see a van, get the plate" and Rina's storm-drain pulse rumor.

- Optional: **never gates** the Spillway exit. Forgiving and replayable.
- Filming sets evidence `northstar_plate`; objective HUD acknowledges it.

## Mood

Early-dusk color block, tonally between Mercy Hill (day) and the Spillway (full
dusk). The "one evening" descends as the player moves toward The Mouth.

## HUD / debug

Same as Mercy Hill: title card, control hint, objective line ("skate Main Street
to the Spillway — film the van if you spot it"). F3 overlay already global.

## Acceptance (played, not read)

- Skate Main Street start → Spillway gate in ~30–40 s.
- Hazard and rail read with enough lead time at route speed.
- Van is reachable and filmable from the board or on foot.
- Missing the risky/awning line is never punishing.
- Ends with the framework Test Checklist for a human feel verdict.

## Out of scope

Final art, tunnel/stealth/chase (later phases), new mechanics, town hub geography
beyond this single route.
