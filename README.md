# Signal Pines

A cinematic 2.5D pixel-art skate mystery adventure set in Cedar Rift, Oregon, 1986.
Current target: the 10–15 minute vertical slice **"The Mouth"**.

Full design: [`SIGNAL_PINES_DESIGN_PLAN.md`](SIGNAL_PINES_DESIGN_PLAN.md)

## Status

**Phase 1–2: skate feel sandbox + Mercy Hill graybox route.**
Everything is placeholder rectangles on purpose — movement feel comes before art.

## Run it

Requires Godot 4.x (`brew install --cask godot`).

```sh
# From the repo root:
/Applications/Godot.app/Contents/MacOS/Godot --path game

# Or open the game/ folder in the Godot editor and press F5.
```

## Controls (keyboard)

| Key | Action |
|---|---|
| W / Up | Push |
| A / D / arrows | Lean / steer |
| Space | Ollie (hold to crouch + charge, release to pop) |
| S / Down | Brake; at speed, powerslide |
| F | Mount / dismount board |
| R | Reset to start |
| F3 | Toggle debug overlay |

Gamepad is mapped per the design doc (RT push, A ollie, B brake, Y mount).

## What to evaluate (Milestone A/B acceptance)

- Is it fun to skate for 60 seconds with no objective?
- Can you recover from mistakes quickly? Is failure readable?
- Are slopes fun rather than punishing?
- Safe line: just ride the hill to the green finish gate.
- Risky line: charged ollie onto the orange ledge, gap to the yellow rail.

Tuning lives in `game/scripts/player/skate_tuning.gd` — every feel value is
exported and documented.

## Project layout

```
game/
  scenes/    Player, routes
  scripts/   player/ camera/ routes/ debug/
.agents/skills/   Agent skills for scoped work on this project
```
