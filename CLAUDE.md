# Signal Pines — Claude Project Context

Read `SIGNAL_PINES_DESIGN_PLAN.md` first.

This project is a Godot 4.x prototype for a cinematic 2.5D pixel-art skate mystery adventure.

Priority:
Build the vertical slice "The Mouth" in small, working increments.

Claude should:
- Keep scope constrained.
- Prefer simple GDScript and scene composition.
- Explain file changes clearly.
- Avoid broad rewrites unless asked.
- Keep movement, camera, mission, interaction, and UI systems separated.
- Use placeholder art and graybox levels first.
- Add debug tooling for movement.
- Preserve the tone: 1980s Pacific Northwest, teen mystery, analog gadgets, lab conspiracy, subtle signal horror.

Verification:
- Run headless to catch script errors:
  `/Applications/Godot.app/Contents/MacOS/Godot --headless --path game --quit-after 120`
- Movement feel must be judged by a human playing the build; never claim "feels good" from code alone.

## Iteration framework (binding)

Full version: `docs/ITERATION_FRAMEWORK.md`. The rules that govern every pass:

1. **One mechanic per pass.** Never add two core mechanics in the same change.
2. **Toy before game.** Each mechanic starts as a crude isolated playable; it
   joins the vertical slice only after a human feel test passes.
3. **Smallest useful amendment.** When feedback says something feels wrong:
   restate the friction in gameplay terms, identify the one system involved,
   change only that. Never rewrite a controller to fix a feel note.
4. **Every feel number is a named `@export`** in `SkateTuning` (or that
   mechanic's tuning resource). No magic numbers in movement logic.
5. **Debug visibility ships with the mechanic**, in the same pass — state,
   speeds, distances, and why a trigger fired. Not optional polish.
6. **Readability before difficulty, predictability before realism.** Coyote
   time, input buffering, forgiving snap, authored cameras — not simulation.
7. **Start slow, sparse, and forgiving.** Tighten speed/density/pressure only
   after the mechanic is understandable and fun.
8. **Cut ruthlessly.** Anything not serving the current toy or The Mouth slice
   goes to backlog.
9. **End every feature with the Test Checklist**: what scene to open, what
   inputs to press, what you should see, what debug values to watch, what
   "feels wrong" would look like, what to report back.
10. **Stop and wait for playtest feedback** before starting the next mechanic.

Live tuning workflow:
- F3 toggles the debug overlay; F4 toggles the tuning panel (live sliders over
  the active `SkateTuning`).
- The player tunes values in-game, presses **Copy changed**, and pastes the
  diff into the chat; Claude persists those numbers into `skate_tuning.gd`
  defaults (or a `.tres` preset).
