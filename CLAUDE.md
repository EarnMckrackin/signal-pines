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
