# Signal Pines — Agent Instructions

Signal Pines is a cinematic 2.5D pixel-art skate mystery adventure set in a fictional 1980s Pacific Northwest town.

Core fantasy:
A teenager uses skateboarding, analog gadgets, and stylized improvised toy-gadgets to investigate a local lab experimenting on teens.

Current priority:
Build a playable vertical slice called "The Mouth."

Do not build the full open world.
Do not add multiplayer.
Do not add procedural generation.
Do not add complex RPG systems.
Do not add a full trick-scoring economy yet.
Do not create real-world weapon construction instructions.

Game pillars:
1. Skate Everywhere
2. Kids Know the Real Map
3. Investigate With Analog Tools
4. Outsmart, Don't Outgun
5. The Town Gets Stranger at Night

Prototype target:
A 10–15 minute playable slice with:
- 2.5D side-view skating controller
- push, crouch, ollie, grind, powerslide, bail/recover
- simple slope momentum
- authored parallax scene layers
- route-based level design
- basic interactables
- simple dialogue
- camcorder evidence capture
- first stealth/chase sequence
- checkpoint restart

Engineering principles:
- Keep systems small and readable.
- Prefer GDScript unless there is a strong reason not to.
- Separate input, movement state, physics, animation hooks, camera, gadgets, and mission logic.
- Expose tuning values.
- Use placeholder assets until game feel is proven.
- Add debug overlays for speed, state, grind detection, grounded state, and active route/lane.
- Favor readable game feel over physically perfect simulation.
- When adding features, explain how they support the vertical slice.
