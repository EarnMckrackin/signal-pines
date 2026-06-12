---
name: skate-line-controller-review
description: Review or implement Signal Pines skating movement, including push, crouch, ollie, grind, slope momentum, powerslide, bail, recovery, and route flow.
---

# Skate Line Controller Review

The skating controller is the most important system in the prototype.

Priorities:
1. Movement should feel responsive, readable, and replayable.
2. The player should feel momentum without losing basic control.
3. Tricks should support route flow, not become a full simulation.
4. The controller should be easy to tune.
5. Code should clearly separate input, movement state, collision, animation hooks, and debug display.

Core movement states:
- OnFoot
- Mounting
- Skating
- Crouching
- Airborne
- Grinding
- Powersliding
- Bailing
- Recovering
- Climbing
- Interacting

Initial mechanics:
- Push
- Brake
- Crouch
- Ollie
- Powerslide
- Grind
- Bail
- Recover
- Dismount

Implementation guidance:
- Use named tuning values for acceleration, friction, jump force, gravity, grind magnetism, landing tolerance, and recovery time.
- Avoid hardcoded magic numbers.
- Include debug output for speed, state, grounded status, and grind target.
- Prefer forgiving inputs: input buffering, short coyote time, and reasonable landing windows.
- Do not implement a full trick combo system until basic movement feels good.

Review checklist:
- Can the player skate for 60 seconds with no objective and still have fun?
- Is failure readable?
- Can the player recover quickly after a bail?
- Are slopes fun rather than punishing?
- Are grind targets understandable?
- Does the camera support the line?
- Does this help the "The Mouth" vertical slice?
