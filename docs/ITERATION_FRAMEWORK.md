# Signal Pines — AI Game Dev Iteration Learnings

**Purpose:** Supplemental framework for Claude/Codex only  
**Use this when building Signal Pines:** Yes  
**Use this to rewrite the game design:** No  
**Source context:** A Reddit post/comment showing how a creator used Claude Fable to rapidly prototype a genre mashup: Tetris as a racing game.

---

## 1. The Core Learning

The useful lesson is not that AI can create a finished game from one prompt.

The useful lesson is:

> **AI game development works best as a tight playtest-and-amend loop.**

The creator started with a clear genre-mash concept, then repeatedly played the result and issued specific amendments based on what felt unclear, broken, too fast, too dense, or not fun yet.

For Signal Pines, this means Claude should not try to build the whole game or perfect a mechanic in one pass.

Claude should:
1. Build one mechanic.
2. Let the user play it.
3. Wait for specific friction.
4. Make a targeted amendment.
5. Preserve tunability and debug visibility.
6. Repeat.

---

## 2. What the Reddit Post Demonstrates

The post/comment shows a useful AI-assisted development pattern:

1. Start with a compact but specific mashup.
2. Implement a crude playable version.
3. Play it immediately.
4. Identify concrete friction.
5. Ask for small amendments.
6. Tune speed, density, camera, collision, visibility, and predictability.
7. Remove features that distract from the core loop.
8. Keep iterating until the game becomes understandable and fun.

The creator did not begin with polish. They began with a playable mechanic.

That is the key behavior Signal Pines should copy.

---

## 3. Translate the Framework to Signal Pines

For Signal Pines, do not prompt:

> Build the whole game.

Instead prompt:

> Build a one-minute 2.5D downhill skate route where the player can push, crouch, ollie, brake, and recover.

Then play it.

Then amend based on feel.

Examples:

- “The skater loses too much speed after landing.”
- “The ollie feels too floaty.”
- “The rail snap is unclear.”
- “I cannot see the next obstacle soon enough.”
- “The route is too dense.”
- “The chase is too fast to read.”
- “The camera hides the landing.”
- “The failure state feels unfair.”
- “The line is not replayable yet.”
- “The controls work technically, but it does not feel fun.”

Claude should expect these amendments and support them with named tuning variables, debug overlays, and small targeted changes.

---

## 4. New Working Principle

### Build the toy before the game.

Every major mechanic should first exist as a crude playable toy.

Signal Pines should be developed through small mechanic toys:

| Prototype Toy | Question It Answers |
|---|---|
| Downhill skate toy | Is basic movement fun? |
| Grind toy | Is rail entry/exit readable? |
| Bail/recovery toy | Does failure feel fair? |
| Chase toy | Can pressure work without confusion? |
| Camcorder toy | Is evidence capture satisfying? |
| Stealth toy | Can skating and sneaking coexist? |
| Yo-yo toy | Does the gadget create a useful verb? |
| Signal distortion toy | Does weirdness improve the route instead of confusing it? |

Do not add a toy to the vertical slice until it passes a basic feel test.

---

## 5. Amendment-Driven Development

Claude should treat user feedback as a design input, not a bug report only.

When the user says something feels wrong, Claude should:

1. Restate the friction in gameplay terms.
2. Identify the likely system involved.
3. Make the smallest useful change.
4. Add or adjust named tuning values.
5. Preserve debug visibility.
6. Explain how to test the change.

Example:

User feedback:
> Landing kills too much momentum.

Claude response should not be:
> I rewrote the movement controller.

Claude should instead:
- Add or adjust `landing_speed_retention`.
- Preserve a configurable range.
- Show speed before/after landing in debug.
- Keep the movement controller structure intact.
- Explain where to test it in the current route.

---

## 6. Prioritize Readability Before Complexity

One major lesson from the Reddit iteration is that the game became better when the creator improved visibility and predictability.

For Signal Pines, that means every mechanic should answer:

> Can the player understand what is about to happen?

Examples:

### Skating
Add visual clarity for:
- Grindable rails
- Landing zones
- Route branches
- Hazards
- Bail risk
- Speed state

### Camcorder
Add visual clarity for:
- Capturable evidence
- Recording state
- Zoom/focus state
- Successful capture

### Stealth
Add visual clarity for:
- Guard vision cones
- Alert state
- Hide zones
- Noise radius

### Chase
Add visual clarity for:
- Upcoming obstacles
- Safe route
- Risk route
- Blocked exits
- Checkpoint direction

### Signal Zones
Add visual clarity for:
- Distorted routes
- Repeating spaces
- Hidden paths
- Reality-shift timing

Do not make the game harder by making it unclear.

---

## 7. Predictable Fun Beats Realism

The Reddit iteration improved when the game became more predictable, not more realistic.

For Signal Pines, do not over-simulate skateboarding.

Prefer:
- Forgiving rail snap
- Input buffering
- Coyote time
- Landing forgiveness
- Readable slope momentum
- Tunable recovery windows
- Clear route affordances
- Authored camera framing

Avoid:
- Hyper-realistic physics
- Punishing landings
- Unclear collision
- Overly sensitive speed loss
- Camera behavior that feels uncontrolled
- Complex trick simulation too early

The design goal is:

> **Cinematic skate flow, not a skateboarding physics simulator.**

---

## 8. Slow First, Then Speed Up

The Reddit post showed repeated pacing adjustments: slower game speed, fewer objects, more spacing, better visibility.

Signal Pines should follow the same principle.

Early prototypes should be:
- Slower than final
- More readable than final
- More forgiving than final
- Less dense than final
- More obvious than final

Once the mechanic is understandable and fun, then increase:
- Speed
- Density
- Pressure
- Route complexity
- Timing difficulty

Do not tune the first prototype as if the player is already skilled.

---

## 9. Remove Distracting Features

The Reddit iteration cut or changed a feature that distracted from the core loop.

Signal Pines should be ruthless about this.

If a system does not improve the current mechanic toy or The Mouth vertical slice, it goes to backlog.

Cut or defer:
- Full trick economy
- Full inventory
- Full reputation system
- Multiple toy weapons
- Procedural town
- Full day/night simulation
- Multiple endings
- Complex enemy AI
- Upgrade trees

Keep early:
- Movement feel
- Route readability
- Grind clarity
- Bail/recovery
- Camcorder clue capture
- One chase
- One stealth reveal
- One strong ending hook

---

## 10. Every Mechanic Needs Debug Visibility

Claude should add debug tools early, not after the system is broken.

For Signal Pines, debug should show:

### Movement Debug
- Current movement state
- Current speed
- Grounded/airborne
- Slope angle
- Input direction
- Crouch charge
- Landing speed retention
- Bail trigger reason

### Grind Debug
- Nearby grind target
- Snap distance
- Active rail
- Grind direction
- Exit point

### Camera Debug
- Current camera zone
- Lookahead amount
- Zoom level
- Target offset

### Stealth Debug
- Guard state
- Vision cone
- Detection meter
- Last known player position

### Mission Debug
- Current objective
- Active checkpoint
- Trigger flags
- Captured evidence

Debug visibility is part of the development framework, not optional polish.

---

## 11. The Correct Claude Loop

Use this loop repeatedly:

```text
1. Build the smallest playable version.
2. Run it.
3. User plays it.
4. User describes friction.
5. Claude makes one targeted amendment.
6. Claude exposes tuning values.
7. Claude preserves debug visibility.
8. User replays.
9. Repeat until the mechanic feels good.
10. Only then integrate into The Mouth vertical slice.
```

---

## 12. Bad Prompts vs Good Prompts

### Bad Prompt

```text
Build the skating system for the whole game.
```

Why it is bad:
- Too broad.
- Encourages over-engineering.
- Hard to test.
- No clear acceptance criteria.

### Good Prompt

```text
Create a one-screen downhill skating prototype.

Include:
- push
- brake
- crouch
- ollie
- landing
- basic speed debug
- one slope
- one small obstacle

Acceptance:
The player should be able to skate for 60 seconds and recover from mistakes quickly.
Do not add tricks, combat, inventory, or story yet.
```

---

### Bad Prompt

```text
Make skating feel better.
```

Why it is bad:
- Too vague.
- Claude may rewrite too much.
- No clear tuning target.

### Good Prompt

```text
The skater feels too floaty.

Please:
- reduce ollie height by 20%
- increase gravity while falling
- preserve horizontal speed on landing
- add named tuning values for jump_force, fall_gravity_multiplier, and landing_speed_retention
- update the debug overlay to show vertical velocity and landing speed retention
```

---

### Bad Prompt

```text
Add a chase sequence.
```

Why it is bad:
- Too broad.
- Risks unfair pacing.
- Hard to debug.

### Good Prompt

```text
Create a 20-second tunnel chase prototype.

Include:
- one forward route
- three readable obstacles
- one checkpoint
- camera lookahead
- slower-than-final speed
- debug labels for obstacle timing

Do not add enemies yet. Simulate pressure with a timer only.
```

---

## 13. Add This Rule to the Project

### The One-Mechanic Rule

Claude should never add multiple new core mechanics in the same pass unless explicitly asked.

Examples:

Do not add:
- skating + combat + gadgets + stealth all at once.

Instead:
1. Add skating.
2. Tune skating.
3. Add grind.
4. Tune grind.
5. Add chase timer.
6. Tune chase.
7. Add guard visibility.
8. Tune stealth.

This prevents mechanic soup.

---

## 14. Add This Rule to Reviews

After each feature, Claude should include:

```md
## Test Checklist

- What scene should I open?
- What inputs should I press?
- What should I see?
- What debug values should I watch?
- What would indicate the feature feels wrong?
- What should I report back after playtesting?
```

This turns every implementation into a playtest loop.

---

## 15. Signal Pines-Specific Implementation Guidance

When implementing Signal Pines mechanics, Claude should prioritize in this order:

1. Feel
2. Readability
3. Predictability
4. Recovery
5. Route flow
6. Debug visibility
7. Extensibility
8. Visual polish

Claude should not prioritize:
- Full realism
- Full system completeness
- Final art
- Large architecture
- Broad feature coverage
- Complex simulation

---

## 16. Summary for Claude

Claude, apply this framework as a supplemental development process.

Do not rewrite the full Signal Pines design plan.

Instead, change how you build:

- Work in tiny playable loops.
- Treat every mechanic as a toy first.
- Make one amendment at a time.
- Add tuning values.
- Add debug visibility.
- Favor predictable fun over realism.
- Improve readability before adding difficulty.
- Cut features that distract from the current loop.
- Do not integrate a mechanic into the vertical slice until it passes a feel test.

The goal is not to generate a complete game quickly.

The goal is to rapidly discover which small playable mechanics are actually fun, then build the vertical slice from only those proven pieces.
