# Signal Pines — Prototype Plan

Target: the 10–15 minute vertical slice **"The Mouth"** (design doc §10–11, §22).

## Build phases

- [x] **Phase 1 — Skate Feel Sandbox**: player controller (push/brake/crouch/ollie/
  powerslide/bail/recover/dismount), slope momentum, debug overlay, tunable values.
- [x] **Phase 2 — Mercy Hill Route** (graybox): sloped street, curb, rail
  placeholder, risky one-way upper line, start checkpoint, finish trigger, camera
  follow. *Awaiting human feel pass — Milestone A/B acceptance is played, not read.*
- [x] **Phase 3 — Grind and Route Mastery**: grind detection, snap tolerance,
  grind state, exit, debug grind target. *Awaiting human feel pass.*
- [x] **Phase 4 — Zip's + Dialogue Hub**: NPC placeholders, dialogue box with
  branching choices, rumor flags, objective flow, scene gate from Mercy Hill.
  *Awaiting human pass on dialogue pacing/tone.*
- [x] **Phase 5 — Camcorder Tool**: [C] viewfinder, evidence targets, hold-[E]
  record with progress, captured flags in GameState, debug evidence list.
  *First real use (Eli's trick + glitch) lands with Phase 6's Spillway.*
- [x] **Phase 6 — Spillway Scene**: dusk-mood-blocked canal, The Mouth (humming
  arch + entry zone), Eli's filmed trick, camcorder glitch + ghost anomaly,
  walkie tone event, Eli enters tunnel, end card. *Awaiting human pass on mood
  and scare readability.*
- [x] **Main Street line** (slice connective route, Zip's → Spillway): graybox
  downhill street, low curb hazard, grind handrail, risky awning branch, optional
  Northstar-van plate camcorder beat (`northstar_plate`, never gates). Mercy Hill's
  post-Zip's gate now leads here; Main Street gates to the Spillway. Smoke test:
  MainStreetSimTest. *Awaiting human feel pass on route flow + hazard placement.*
- [ ] **Phase 7 — Tunnel Traversal**: dismount/carry/crawl/climb, door wedge.
- [ ] **Phase 8 — Stealth Follow**: guard patrol, detection cone, hide zones, reveal.
- [ ] **Phase 9 — Tunnel Chase**: forced escape, obstacles, flashlight cones.
- [ ] **Phase 10 — Bedroom Playback**: TV/VCR cutscene, Eli message, end card.

## Feel backlog (from Devin's playtests)

- [ ] **Push timing skill**: kick rhythm should matter, not just kick count —
  e.g. a slightly stronger kick when timed near the top of the roll (as the
  previous kick's burst decays), like EA Skate's push cadence. Current state:
  tap-to-push at flat 185 impulse, 0.3 s cooldown, 540 cap, slopes required to
  exceed it. Keep the cap physical; reward timing inside it.

## Environment & art direction

- [x] **Atmosphere system** (2026-06-13): shared, config-driven environment
  (`scripts/env/`): sky gradient, Parallax2D depth layers, CPUParticles2D,
  color grade, foreground occluders. Procedural silhouettes now; AI-sprite
  texture slots ready. `RoutePalettes` holds per-route palettes; F5 debug
  readout. Applied to all three routes; Spillway's inline mood refactored onto
  it. `tools/Capture.tscn` = windowed screenshot harness. *Awaiting human look
  verdict + AI-sprite swap (gated on HF auth).*

## Rules

- Every feature must serve the vertical slice or go to the backlog (design doc §27).
- Movement feel gates everything: do not advance past Phase 3 until a human says
  skating is fun for 60 seconds with no objective.
- ~~Placeholder art only until route flow is proven.~~ **Overridden 2026-06-13**
  at Devin's direction: environment art direction (incl. AI-generated sprites)
  is being done now, ahead of the movement feel verdict. Recorded in
  `docs/superpowers/specs/2026-06-13-environment-art-direction-design.md`.
