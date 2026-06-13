# Environment & Art Direction — Design

**Date:** 2026-06-13
**Scope:** All routes (Mercy Hill, Main Street, Spillway) brought to an
art-directed bar in one pass, with AI-generated pixel-art sprites.
**Status:** approved, building

## Decisions (from brainstorming)

- **Breadth:** full treatment across all three routes this pass.
- **Medium:** real pixel-art assets, generated via an AI image model (HuggingFace).
- **Depth ingredients:** parallax layers, ambient particles, animated dressing,
  foreground occluders — all four.
- **Override on record:** this reverses the design plan's deferral of rendered
  art to Milestone F and the iteration framework's "polish last / feel-gates-
  first" ordering. Done with eyes open at the user's direction; plan docs updated
  to match. Movement still has not had its human feel verdict.

## Architecture

### `Atmosphere` (scripts/env/atmosphere.gd + scenes/env/Atmosphere.tscn)
A node dropped into a route. Reads an `AtmosphereConfig` and builds, in order:
1. Parallax layers (`Parallax2D` per layer, each with a `Sprite2D`), far → near.
2. A `CanvasModulate` color grade.
3. Particles (`CPUParticles2D`, one per configured emitter).
4. Animated dressing (fog drift, light flicker, treeline) via reusable helpers.
5. Foreground occluder layer (`Parallax2D` with `scroll_scale > 1`).

It depends only on the config and the active `Camera2D` (the player's
`CinematicCamera`, which `Parallax2D` follows automatically). No route logic
leaks in; a route just instances `Atmosphere` and points it at a config.

### `AtmosphereConfig` (scripts/env/atmosphere_config.gd extends Resource)
The environment's `SkateTuning` — the tunable home for art direction.
- `sky_top: Color`, `sky_bottom: Color`, `grade: Color`
- `layers: Array[AtmosphereLayer]` — each: `texture: Texture2D`, `scroll_scale:
  Vector2`, `z_index: int`, `offset: Vector2`, `tint: Color`, `repeat: bool`
- `particles: Array[AtmosphereEmitter]` — preset enum (DUST/MIST/EMBERS/RAIN),
  region, amount, tint
- `occluders: Array[AtmosphereLayer]` — same shape, `scroll_scale > 1`
- `fog_enabled/fog_color/fog_count`
Saved as `.tres` per route under `game/assets/env/configs/`.

Empty `texture` slots fall back to a **procedural** generator (gradient sky,
silhouette treeline/hills, noise haze) so the system runs and reads as
deliberate art *before* any AI sprites exist. AI art is a later swap into these
slots, not a rewrite.

### Renderer note
Project uses `gl_compatibility`. Use `CPUParticles2D` (not GPU) and plain
`Sprite2D`/`Parallax2D`; avoid features unsupported on the compatibility backend.

## AI-art pipeline (gated on HF auth)

`tools/gen_env_art.py`:
- One locked style prefix: "1986 Pacific Northwest small town, side-scrolling
  game background layer, limited-palette pixel art, painterly, no characters,
  seamless horizontal" + per-layer/per-mood suffix.
- Generate per route/layer via HF text-to-image (Inference Providers / a Space).
- Post-process: nearest-neighbor downscale for pixel feel, palette quantize,
  horizontal seam-fix for tiling layers, alpha-cut for props/occluders.
- Write to `game/assets/env/<route>/<layer>.png`; wire into the `.tres` configs.
- Expect several regen passes and some hand-cleanup; diffusion pixel-art is rough.
- Requires the user to authenticate HuggingFace (browser OAuth step).

## Per-route application

- **Mercy Hill** — day palette: hills + treeline parallax, dust motes,
  telephone-pole occluders. (Currently bare.)
- **Main Street** — early dusk: storefront-row parallax backdrop, drifting
  leaves, streetlight/sign flicker, pole occluders. Replaces the flat dusk rect.
- **Spillway** — refactor the inline mood (sky/ember bands, treeline, fog,
  graffiti) onto the system; dusk palette, mist + embers. The Mouth arch and its
  pulse stay scene-specific (mission art, not atmosphere).

## Debug / tuning

F5 toggles an atmosphere readout: active config name, per-layer scroll scales,
particle presets, fps. Palette/scroll values live in the `.tres`, retunable
without touching scene code.

## Verification

- Headless load of every route (no script errors).
- All four existing sim tests stay green (Mercy Hill, Zip's, Spillway, Main St).
- Screenshots of each route captured and sent to the user — art direction is
  judged by eye, so a visual verdict step, not just "it loads."
- Per-route Test Checklist for the human look pass.

## Build sequence (this pass)

1. `Atmosphere` + `AtmosphereConfig` + helpers, procedural textures.
2. Apply to all three routes; refactor Spillway onto the system.
3. Verify (headless + sim tests + screenshots).
4. After HF auth: generate + post-process + swap real sprites → re-screenshot.

## Out of scope

Character/NPC sprites, final UI art, tunnel/stealth/chase phases, audio.
