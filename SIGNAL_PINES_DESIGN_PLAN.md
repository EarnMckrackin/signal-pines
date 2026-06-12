# Signal Pines — Complete Design & Build Plan

**Version:** 0.1  
**Purpose:** Shareable design/build plan for Codex, Claude Code, or another coding agent  
**Working title:** Signal Pines  
**Format:** Cinematic 2.5D pixel-art skate mystery adventure  
**Primary prototype target:** A 10–15 minute vertical slice called **“The Mouth”**

---

## 0. Agent Usage Instructions

Use this document as the canonical project brief.

When working from this file:

1. Do **not** build the full game first.
2. Build the vertical slice first.
3. Prioritize skating feel before story expansion, combat, inventory, or open-ended systems.
4. Use placeholder art until movement, route flow, and mission beats are proven.
5. Keep systems small, readable, and easy to tune.
6. Never copy protected mechanics, code, characters, names, or art direction directly from any reference. The goal is inspiration, not imitation.
7. Treat toy-weapons as stylized fictional game gadgets only. Do not provide real-world construction details for weapons.

---

## 1. One-Line Pitch

**Signal Pines** is a cinematic 2.5D pixel-art adventure where a teenage skater in a strange 1980s Pacific Northwest town uses skateboarding, analog gadgets, and improvised toy-like tools to uncover a secret lab experimenting on local teens.

---

## 2. High Concept

The player is a teenager in **Cedar Rift**, a fading timber town in the Pacific Northwest in 1986. The town looks ordinary to adults: school, diner, arcade, mill, lake, forest, and a government-adjacent research campus. But to local teens, it is a hidden skate map of storm drains, rooftops, alleys, empty pools, service tunnels, and forbidden routes.

After the player’s best friend **Eli Voss** disappears inside a drainage tunnel called **The Mouth**, the player and their crew uncover evidence that **Northstar Research** has been abducting and experimenting on teens who are unusually responsive to a strange signal buried beneath the town.

The game blends:
- Cinematic 2.5D platforming
- Skate-line movement
- Mystery investigation
- Stealth and chase sequences
- Analog gadget puzzles
- Light non-lethal combat with stylized toy-gadget tools

The fantasy is not “I can go anywhere in a giant open world.”

The fantasy is:

> **I know the line nobody else sees.**

Adults see roads, gates, fences, and curfew.  
The player sees rails, rooftops, storm drains, arcade back doors, service tunnels, and signal-warped shortcuts.

---

## 3. Creative Pillars

Every feature should support at least one of these pillars.

### 1. Skate Everywhere

The skateboard is the player’s main identity, transport, escape tool, and expression system.

Skating should be useful in:
- Traversal
- Chases
- Route mastery
- Stealth escapes
- Trick-based reputation
- Environmental puzzle solving
- Cinematic set pieces

### 2. Kids Know the Real Map

Cedar Rift has two maps:

- The adult map: streets, roads, locked doors, official entrances.
- The kid/skater map: alleys, rooftops, rails, tunnels, ditches, fences, drainage routes.

The player progresses by learning and unlocking the second map.

### 3. Investigate With Analog Tools

The investigation should feel 1980s and tactile.

Core tools:
- Camcorder
- VHS tapes
- Walkie-talkie
- Radio scanner
- View-Master-style anomaly viewer
- Notebook/clue board
- RC car gadget
- Arcade cabinets
- Payphones
- Microfiche/newspaper records

### 4. Outsmart, Don’t Outgun

The player is not a soldier. They are a clever, reckless teen.

Conflict should focus on:
- Stun
- Distract
- Trip
- Escape
- Disable devices
- Use the environment
- Avoid detection
- Survive

Combat should be stylish but not military.

### 5. The Town Gets Stranger at Night

Cedar Rift should transform after dark.

Night introduces:
- Curfew patrols
- Lab vans
- Fog
- Stronger signal effects
- Hidden NPCs
- Changed routes
- VHS distortions
- Memory echoes
- Anomaly encounters

---

## 4. Format Decision

### Chosen format

**Cinematic 2.5D pixel-art adventure.**

This means:
- Mostly side-view gameplay.
- Layered foreground/midground/background environments.
- Controlled cinematic camera.
- Parallax depth.
- Authored scenes and routes.
- Occasional depth-lane transitions.
- Strong lighting, fog, silhouettes, and VHS effects.

### Why 2.5D

The original concept was a 3D open-world skating adventure. That version is exciting but too large for a practical solo/small-team prototype.

The 2.5D version preserves the core fantasy while reducing the most dangerous production risks:
- No full 3D open-world city.
- No free 3D action camera.
- No complex 3D skate simulation.
- No enormous traversal animation matrix.
- No GTA-like systemic world.

The game becomes:
> **A route-based mystery adventure where movement mastery reveals the hidden town.**

---

## 5. Visual Target

### Reference lane

The game should aim for a cinematic, high-style pixel look: dense silhouettes, atmospheric depth, dramatic lighting, and modern effects layered over pixel-art characters and environments.

Do not clone any reference. Use them as directional inputs only.

### Art direction phrase

**1980s Pacific Northwest pixel noir.**

### Visual ingredients

- Wet pavement
- Pine silhouettes
- Sodium streetlights
- Arcade neon
- Foggy forests
- Concrete spillways
- Chain-link fences
- Empty pools
- Wood-paneled bedrooms
- School hallways
- Red lab warning lights
- VHS distortion
- Rain on asphalt
- Distant radio towers
- Powerline cuts through the woods
- Missing-person flyers
- Flickering fluorescent labs

### Color worlds

#### Day
Warm, faded, nostalgic:
- Sun-bleached pavement
- Washed-out blue sky
- Old brick
- Faded red signage
- Dusty greens

#### Dusk
Adventure and danger:
- Orange sky
- Purple shadows
- Long silhouettes
- Deepening blues

#### Night
Mystery and pursuit:
- Blue-black shadows
- Fog
- Headlights
- Neon
- Wet reflections

#### Lab
Sterile and hostile:
- White
- Green
- Red emergency lighting
- Harsh silhouettes
- Overexposed corridors

#### Signal zones
Unnatural:
- Cyan/magenta fringing
- Blown-out whites
- VHS tearing
- Impossible shadows
- Geometry that feels repeated or misaligned

---

## 6. Setting

### Town

**Cedar Rift, Oregon**  
A fictional timber town in the Pacific Northwest.

It sits between:
- Dense pine forest
- A dying mill district
- A cold inland lake
- A concrete spillway system
- Steep residential hills
- A government-adjacent research campus
- Old mining and utility tunnels

### Public history

Cedar Rift used to be a thriving logging and paper town. By 1986, the mill is shrinking, storefronts are closing, and adults are worried about jobs.

Northstar Research has become the town’s uneasy lifeline. It funds school programs, sponsors scholarships, hires locals, and quietly buys influence.

### Hidden history

In the late 1960s, something was discovered beneath the ridge north of town. The official story is a meteorological anomaly. The real story is a signal source: possibly alien, extradimensional, or something older than human technology.

Northstar has spent years trying to decode it.

The problem: teens can perceive and survive exposure to the signal better than adults.

---

## 7. Major Locations

### The Ridge

A hilly residential area with:
- Steep streets
- Driveways
- Empty pools
- Construction lots
- Sprinklers
- Suburban shortcuts
- Early downhill tutorial routes

Gameplay role:
- Skating tutorial
- Safe/stylish/risky route structure
- First sense that the town is a skate map

### Zip’s Diner & Arcade

Teen social hub.

Features:
- Diner counter
- Arcade cabinets
- Payphone
- Rumors
- Rival skaters
- Clue drops
- Music and neon
- Crew conversations

Gameplay role:
- Dialogue hub
- Rumor system
- Mission start point
- Arcade cabinet anomaly later in game

### Main Street

Small-town commercial strip.

Features:
- Movie theater rail
- Bank plaza
- Grocery loading dock
- Alley shortcut
- Police presence
- Shopfronts
- Streetlights
- Public phones

Gameplay role:
- First structured skate-line challenge
- Reputation system intro
- Chase route later at night

### Cedar Rift High

School hub.

Features:
- Lockers
- Gym
- Roof
- AV room
- Nurse’s office
- Records
- Social factions
- Detention

Gameplay role:
- Clues about testing programs
- Social investigation
- Stealth missions
- Rooftop traversal

### Mill District

Industrial traversal space.

Features:
- Catwalks
- Conveyor belts
- Loading docks
- Rail spurs
- Rusted machinery
- Abandoned offices
- Locked gates
- Worker NPCs

Gameplay role:
- Vertical 2.5D traversal
- Action set pieces
- Hidden routes into older tunnel network

### The Spillway

Massive concrete drainage canal.

Features:
- Graffiti
- Sloped concrete
- Echoes
- Standing water
- Service doors
- Huge tunnel outlet called The Mouth

Gameplay role:
- First “wow” location
- First anomaly
- Eli disappearance
- Vertical slice climax

### Lake Mercy

Quiet, unsettling lake area.

Features:
- Docks
- Cabins
- Fog
- Boathouses
- Old local legends
- Missing teen history

Gameplay role:
- Historical mystery
- Midgame clues
- Stranger supernatural tone

### Northstar Research

Research campus on the edge of town.

Public face:
- Neuroscience
- Communications
- Energy research
- School scholarship programs

Secret function:
- Signal research
- Teen subject testing
- Underground access
- Containment chambers
- Psychological stress experiments

Gameplay role:
- Main antagonist location
- Late-game infiltration
- Moral ambiguity

### The Black Pines

Deep forest beyond town.

Features:
- Logging roads
- Ranger towers
- Powerline routes
- Hidden bunkers
- Strange animal behavior
- Signal distortions

Gameplay role:
- Night exploration
- Survival tone
- Hidden entrances
- Mid/late-game anomaly routes

---

## 8. Main Characters

### Player Character

A customizable teenage skater, age 16 or 17.

The player is an outsider enough to discover Cedar Rift with fresh eyes, but not so detached that they feel unrelated to the town.

Possible selectable backgrounds:
- Parent works at the mill.
- Parent works at the hospital.
- Parent works at the school.
- Parent works at Northstar.
- Player recently moved in with a relative.

Do not overcomplicate this in the prototype. Use one default background first.

### Eli Voss

Best friend. Missing person. Amateur filmmaker. Conspiracy obsessive. Reckless, funny, and convinced Cedar Rift is hiding something.

Role:
- Emotional hook
- Inciting incident
- VHS tape narrator
- Mystery object
- Possible unstable witness from another timeline

Eli’s energy:
- “One good tape and we’re legends.”
- Believes weird things before anyone else.
- Annoying in a lovable way.
- Makes everything feel like an adventure until it becomes real.

### Rina Park

Tech brain of the crew.

Role:
- Walkie/radio tools
- Scanner upgrades
- RC car modifications
- Signal analysis
- AV room access

Personality:
- Dry, skeptical, mechanically brilliant.
- Hates being called a genius.
- Builds useful tools out of junk because adults underestimate her.

### Cal Mercer

Local skate legend and rival-turned-ally.

Role:
- Teaches advanced lines.
- Knows secret routes.
- Has local credibility.
- Has reasons to distrust adults.

Personality:
- Cool, guarded, competitive.
- Pretends not to care.
- Knows the town physically better than anyone.

### June Bell

School paper editor and local-history hunter.

Role:
- Records, old newspapers, town history.
- Connects disappearances across decades.
- Tracks contradictions in the official story.

Personality:
- Sharp, stubborn, moral.
- Less physically reckless than the others, but braver than she thinks.

### Sheriff Harlan Vale

Local sheriff.

Role:
- Authority figure.
- Possible protector.
- Possible collaborator.
- Knows more than he admits.

Design:
- Not a cartoon villain.
- He may believe secrecy prevents panic.
- He may have lost someone to the signal before.

### Dr. Miriam Kael

Lead scientist at Northstar.

Role:
- Main human face of the conspiracy.
- Believes the experiments are awful but necessary.
- Thinks something is coming through the signal.

Design:
- Morally compromised.
- Intellectually honest in private.
- Dangerous because she believes she is preventing something worse.

---

## 9. Story Overview

### Act 1 — The Missing Tape

The player spends a final summer evening skating with Eli and the crew. Eli disappears inside The Mouth after witnessing Northstar moving a sedated teen through the storm-drain network.

Adults say Eli ran away.

The player has the tape.

Core question:
> Where did Eli go?

### Act 2 — The Signal Kids

The crew discovers Northstar has been identifying “resonant” teens through fake school tests, medical programs, sports physicals, scholarships, and psychological evaluations.

Some teens come back changed. Some never come back.

Core question:
> Why are certain teens being selected?

### Act 3 — The Thing Beneath Cedar Rift

The crew learns that Northstar found a signal source beneath the ridge. The lab thought it was a transmitter, but it may be a door, a distress beacon, a lure, or a living intelligence.

Eli may be alive, but not fully synchronized with the same timeline.

Core question:
> Is Northstar protecting the town from the signal, feeding the signal, or both?

---

## 10. Prototype Story Scope

The prototype only covers the opening vertical slice.

### Prototype title

**The Mouth**

### Prototype summary

The player spends one evening with Eli, learns the core movement, meets the crew, skates to the Spillway, enters The Mouth, witnesses Northstar moving a teen through the tunnels, triggers a signal event, and loses Eli.

The demo ends in the player’s bedroom as the damaged camcorder tape plays impossible footage of Eli after his disappearance.

---

## 11. First 15-Minute Vertical Slice

### Mission 1 — Mercy Hill

Purpose:
- Teach skating.
- Establish Eli and Cal.
- Show Cedar Rift as a skateable town.

Location:
- The Ridge.

Gameplay:
- Player starts at the top of a hill.
- Eli films.
- Cal challenges player to bomb the hill.
- Player learns push, brake, crouch, ollie, powerslide, bail/recover.

Route options:
- Safe road route.
- Stylish curb/driveway route.
- Risky construction shortcut.

Success:
- Player reaches bottom.
- Eli reacts based on style/risk.
- Cal establishes rivalry/credibility.

### Mission 2 — Zip’s After School

Purpose:
- Introduce crew and rumors.
- Establish social hub.
- Seed mystery.

Location:
- Zip’s diner/arcade.

Gameplay:
- Talk to Rina, June, Cal, Eli, rival skaters.
- Hear rumors about The Mouth, Northstar vans, curfew, and missing teens.
- Eli lets player use camcorder.

Optional details:
- Arcade cabinet glitches briefly.
- Deputy at counter warns kids about curfew.
- Northstar recruitment flyer on community board.

### Mission 3 — Main Street Line

Purpose:
- First structured skate challenge.
- Teach route mastery and reputation.

Location:
- Main Street.

Gameplay:
- Rival skater Troy challenges player.
- Route includes rail, alley, bank plaza, loading dock, and shortcut.
- Player can win or lose; story continues either way.

Story beat:
- Northstar van passes behind mill gate.
- Eli notices.

### Mission 4 — Before Sunset

Purpose:
- Let player travel semi-freely to The Spillway.
- Introduce hand-drawn map and route choice.

Location:
- Main Street to Spillway.

Gameplay:
- Choose safer road route, alley route, rail route, or drainage route.
- Optional micro-events:
  - Younger kid looking for lost toy.
  - Cop telling kids to stop skating near the mill.
  - Strange radio pulse near storm drain.
  - Locked service gate foreshadowing future tools.

### Mission 5 — Film the Trick

Purpose:
- Introduce camcorder as investigation tool.
- First anomaly.

Location:
- The Spillway.

Gameplay:
- Player films Eli attempting a trick near The Mouth.
- Camcorder glitches.
- For one second, footage shows Eli standing at the tunnel entrance while he is still beside the player.
- Rina’s radio picks up a tone.

Story beat:
- Tunnel hums.
- Birds erupt from trees.
- Eli insists on going in.

### Mission 6 — Inside The Mouth

Purpose:
- Introduce hybrid traversal.
- Shift tone from teen adventure to conspiracy.

Location:
- Inside storm-drain tunnel.

Gameplay:
- Dismount from board.
- Carry board through water.
- Crawl under pipe.
- Climb over grate.
- Wedge door with board.
- Drop back onto board for short tunnel slope.

Story beat:
- Player and Eli find a modern electronic lock inside an old storm drain.
- They hear Northstar personnel.

### Mission 7 — Unauthorized Access

Purpose:
- First stealth section.
- Reveal Northstar’s hidden tunnel network.

Location:
- Underground transfer station.

Gameplay:
- Follow guards.
- Hide behind pipes.
- Avoid flashlights.
- Move during loud machinery.
- Observe gurney with sedated teen.

Story beat:
- Player sees teen ID photos on a board.
- One photo is Eli.
- Another may be the player.

### Mission 8 — Runoff

Purpose:
- First chase.
- Combine skating, fear, and anomaly.

Location:
- Tunnel escape route.

Gameplay:
- Northstar spots player and Eli.
- Player jumps onto board.
- Dodge pipes.
- Ollie broken grates.
- Powerslide corners.
- Avoid flashlight cones.
- Escape a van in the service tunnel.

Signal event:
- Tunnel repeats.
- Same red light appears three times.
- Eli appears ahead and behind.
- Walkie emits second tone.

### Mission 9 — Eli Disappears

Purpose:
- Inciting incident.

Location:
- Tunnel split near sealed chamber.

Story beat:
- Eli sees something the player cannot.
- He says: “Wait… that’s my house.”
- Player sees only darkness and lab lights.
- Tunnel distorts.
- White blast knocks player back.
- Player wakes at Spillway entrance.
- Eli is gone.

### Mission 10 — Curfew

Purpose:
- Introduce night-state town and patrol pressure.

Location:
- Spillway to player’s house.

Gameplay:
- Skate home after curfew.
- Avoid cops, headlights, and lab vans.
- Hide if needed.
- No hard fail; getting caught changes immediate scene.

### Mission 11 — Playback

Purpose:
- End with mystery hook.

Location:
- Player bedroom.

Gameplay:
- Player plays damaged camcorder tape on TV/VCR.
- It shows normal footage, then impossible footage of Eli after disappearance.

Final line:
> “If you’re seeing this, they already know about you.”

Cut to static.

End card:
**Chapter One: Missing Persons**

---

## 12. Core Gameplay Loop

1. Hear a rumor or receive a clue.
2. Choose a destination on the hand-drawn town map.
3. Skate through a route with safe, stylish, risky, and secret paths.
4. Investigate a scene using analog tools.
5. Trigger a chase, stealth encounter, social confrontation, or anomaly.
6. Escape or solve the route through movement mastery.
7. Return evidence to the crew.
8. Unlock new routes, clues, gear upgrades, and story branches.

---

## 13. Movement System

### Target feel

Movement should feel:
- Responsive
- Momentum-based
- Forgiving enough for story players
- Deep enough for mastery
- Stylish without requiring a huge trick list
- Fast to recover after mistakes

### Core states

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

### Core inputs

Keep initial controls simple.

Suggested gamepad mapping:

- Left stick: move / lean
- A / Cross: ollie / jump
- Hold A / Cross: crouch / charge ollie
- X / Square: interact / use gadget
- B / Circle: brake / powerslide
- Y / Triangle: mount/dismount
- Right trigger: push / accelerate
- Left trigger: slow / focus / camcorder aim
- Shoulder buttons: gadget cycle
- Right stick: look / camera nudge in authored spaces

Keyboard mapping should exist but is not the initial design target.

### Mechanics

#### Push

- Adds forward momentum.
- Should not require button mashing.
- Repeated pushing can add speed up to a tunable cap.
- On slopes, pushing blends with gravity/momentum.

#### Crouch

- Lowers posture.
- Charges ollie.
- Helps duck under obstacles.
- Improves stability at speed.

#### Ollie

- Jump from board.
- Height depends on charge.
- Should support small obstacle clearing and route timing.
- Use input buffering and coyote time.

#### Powerslide

- Quick deceleration / turn / obstacle dodge.
- Should preserve some style and speed.
- Useful in chases.

#### Manual

- Optional after first movement prototype.
- Used for advanced line flow.
- Do not build trick economy before base movement feels good.

#### Grind

- Detect rail targets.
- Snap lightly when player is close enough and holding/pressing grind input.
- Move along rail path.
- Exit by jump, rail end, or bail.
- Needs debug visualization.

#### Bail / recover

- Failure should be readable and fast.
- Bail should not feel punitive during early prototype.
- Recovery timing should be tunable.
- Major bails can matter in chases; minor bails should preserve flow.

#### Dismount

- Player can leave board for climbing, crawling, stealth, and interactions.
- Board should remain visible and recoverable.
- Re-mount should be quick.

---

## 14. 2.5D Route Design

### Route types

Every major route should support:

#### Safe path
Easy, reliable, slower.

#### Style path
More tricks, rails, and reputation opportunities.

#### Risk path
Fast but dangerous, requires timing.

#### Secret path
Hidden route leading to clue, shortcut, collectible, or alternate encounter.

### Route readability principles

- The main path must be visually obvious.
- Risky paths should be tempting but clearly risky.
- Secret paths should be discoverable through observation, rumor, or gadgets.
- Rail/grind targets need clear visual language.
- Foreground/background path transitions should be explicit and readable.
- Chases should avoid unfair blind jumps.

### Depth lanes

Use depth sparingly.

Possible lanes:
- Foreground lane
- Main lane
- Background lane
- Rooftop/upper lane
- Tunnel/service lane

Lane transitions can happen via:
- Ramps
- Doors
- Alleys
- Stairs
- Rooftop drops
- Drainage culverts
- Signal distortions

Do not build free depth movement at first. Author lane transitions as specific route moments.

---

## 15. Investigation Systems

### Camcorder

Prototype functions:
- Aim/record at marked evidence.
- Capture suspicious object.
- Playback cutscene clips.
- Reveal distortion in signal zones.

Later functions:
- Frame-based evidence quality.
- Record anomalies invisible to eye.
- Collect replayable tapes.

### View-Master Scanner

Prototype later, not in first build.

Functions:
- Reveal hidden symbols.
- Show memory echoes.
- Expose invisible route markers.
- See old versions of locations.
- Detect signal interference.

### Walkie/Radio Scanner

Functions:
- Detect signal strength.
- Tune to frequencies.
- Open frequency locks.
- Communicate with crew.
- Later: sonic stun/disruption.

### Notebook / Clue Board

Prototype can be a simple UI screen.

Tracks:
- Missing teens
- Northstar evidence
- Locations
- Crew theories
- VHS tapes
- Contradictions
- Unlocked routes

### Rumor System

NPCs provide partial information.

Rumor types:
- True clue
- Misdirection
- Social gossip
- Route hint
- Historical clue
- Warning
- Foreshadowing

For prototype:
- Use hand-authored dialogue flags.
- Do not build a complex dynamic rumor engine.

---

## 16. Gadget and Toy-Tool Kit

Important safety/design note:
These are stylized fictional game gadgets. The project should avoid real-world construction details for harmful weapons.

### Skateboard

Primary tool.

Uses:
- Movement
- Route mastery
- Door wedge
- Bridge small gap
- Distract with noise
- Escape

### Spiked Yo-Yo

Signature fictional tool/weapon.

Gameplay role:
- Mid-range stun
- Trip
- Pull small objects
- Hook switches
- Disable flashlight/shield
- Grapple to marked points
- Disrupt signal creatures later

Narrative origin:
- Eli and Rina built the original prototype as a ridiculous skate-video stunt gadget.
- After Eli disappears, the player finds it in Eli’s garage.
- Rina helps make it safer and useful.
- It becomes a tribute to Eli and a symbol of reckless teen invention.

Do not include detailed crafting instructions.

### Slingshot

Gameplay role:
- Precision ranged tool.

Uses:
- Hit switches
- Knock out lights
- Distract guards
- Break bottles
- Launch signal pellets later

### RC Car Disruptor

Gameplay role:
- Stealth/puzzle tool.

Uses:
- Scout under doors.
- Drive through vents.
- Distract guards.
- Disable cameras.
- Carry small evidence item.

### Walkie Sonic Blaster

Gameplay role:
- Signal/anomaly tool.

Uses:
- Jam radios.
- Briefly stun enemies.
- Open frequency locks.
- Repel signal creatures.

### View-Master Scanner

Gameplay role:
- Investigation/anomaly tool.

Uses:
- Reveal hidden routes.
- See memory echoes.
- Detect invisible lab markings.

### Boom Box Shockwave

Gameplay role:
- Heavy set-piece gadget, not normal combat spam.

Uses:
- Area distraction.
- Break glass.
- Interrupt anomaly pulse.
- Trigger environmental objects.

### Pogo Stick Ram

Hold for later or optional side route.

Gameplay role:
- Traversal/combat oddity.

Uses:
- Reach special route.
- Break weak floors.
- Knock back enemies.

Do not include in prototype unless movement is already solid.

---

## 17. Enemy and Encounter Design

### Human enemies

#### Cops
- Curfew enforcement.
- Patrol streets at night.
- Chase but rarely enter deep kid routes.
- Can be evaded or hidden from.

#### Northstar Security
- More dangerous.
- Guard facilities, tunnels, vans.
- Use flashlights, radios, locked doors, cameras.
- Should feel like adults with institutional power, not generic soldiers.

#### School authority
- Teachers, principal, hall monitors.
- Social/stealth pressure.
- Low danger but high inconvenience.

#### Rival skaters
- Challenge player.
- Gate reputation.
- May become allies.

### Non-human / anomaly threats

Use sparingly.

Possible types:
- Signal echoes: ghostlike repeats of people/events.
- Distorted animals: not monsters everywhere, but rare unsettling encounters.
- Lab subjects: teens changed by exposure, treated with empathy.
- Signal creatures: ambiguous, more environmental than combat-focused.

### Encounter philosophy

Most encounters should ask:
- Can the player escape?
- Can the player distract?
- Can the player route around?
- Can the player use a gadget?
- Can the player use skating skill?

Combat should not become the dominant loop.

---

## 18. Progression

### Prototype progression

Only include:
- Basic movement tutorial.
- Camcorder use.
- One or two route unlocks.
- No XP system.
- No inventory bloat.
- No upgrade tree.

### Full game progression

#### Movement mastery
- Better balance
- Faster recovery
- Longer grinds
- Cleaner landing
- Better slope control

#### Gear
- Decks
- Wheels
- Trucks
- Shoes
- Backpack capacity

Each gear item should alter feel modestly, not create RPG math bloat.

#### Gadgets
- Camcorder night mode
- Radio scanner range
- RC car battery
- Yo-yo signal charge
- View-Master stability

#### Social reputation
Groups:
- Skaters
- Nerds/AV kids
- Burnouts
- Jocks
- Younger kids
- Mill workers
- Teachers

Reputation unlocks:
- Routes
- Rumors
- Safe houses
- Tools
- Shortcuts
- Side missions

---

## 19. UI/UX Direction

### UI style

Handmade analog interface:
- Notebook pages
- Stickers
- Tape labels
- Polaroids
- VHS timestamps
- Hand-drawn map
- Red pen circles
- Cassette labels
- Arcade fonts used sparingly

### HUD

Keep minimal:
- Current objective
- Speed/state debug in dev only
- Gadget indicator
- Health/stamina if needed
- Detection meter during stealth
- Curfew warning at night

### Map

Hand-drawn Cedar Rift map.

Not a GPS minimap.

Map shows:
- Districts
- Known routes
- Rumored routes
- Locked routes
- Crew notes
- Evidence pins

### Accessibility basics

Include from early:
- Remappable controls
- Subtitles
- Text speed options
- Camera shake toggle
- Screen flash reduction
- High-contrast interact prompts
- Assist mode for skating difficulty later
- Color-independent signals for puzzles

---

## 20. Audio Direction

### Music

Tone:
- 1980s synth
- Northwest melancholy
- Arcade warmth
- Dread under nostalgia

Music states:
- Free skating
- Social hub
- Sneaking
- Chase
- Signal anomaly
- VHS playback
- Lab interior

### Sound design

Important sounds:
- Skate wheels on different surfaces
- Board impact
- Rail grind
- Wet tunnel echo
- Walkie static
- VHS tracking noise
- Arcade cabinet hum
- Distant sirens
- Lab fluorescent buzz
- Signal tone

The signal should have an identifiable audio motif.

---

## 21. Technical Recommendation

### Engine

Recommended prototype engine:
**Godot 4.6.x**

Reason:
- Strong 2D workflow.
- Lightweight project structure.
- Good for solo/small-team iteration.
- Easier for coding agents to modify than heavy engine C++ workflows.
- Good fit for 2D scenes, nodes, scripts, signals, TileMapLayer-style tile workflows, animation, and parallax.

### Language

Use:
- GDScript for prototype.
- Keep scripts readable.
- Avoid premature optimization.
- Add type hints where helpful.
- Use scene composition cleanly.

### Project shape

```text
signal-pines/
  README.md
  GAME_BIBLE_LITE.md
  PROTOTYPE_PLAN.md
  AGENTS.md
  CLAUDE.md

  .agents/
    skills/
      godot-2.5d-gameplay-prototyper/
        SKILL.md
      skate-line-controller-review/
        SKILL.md
      cinematic-pixel-art-direction/
        SKILL.md
      vertical-slice-planner/
        SKILL.md
      narrative-mystery-designer/
        SKILL.md
      2.5d-level-design-review/
        SKILL.md

  game/
    project.godot
    scenes/
      player/
        Player.tscn
      routes/
        MercyHill.tscn
        MainStreet.tscn
        Spillway.tscn
        MouthTunnel.tscn
      ui/
        HUD.tscn
        DialogueBox.tscn
        Notebook.tscn
      missions/
        MissionController.tscn
      interactables/
        EvidenceItem.tscn
        Door.tscn
        CameraTarget.tscn
      enemies/
        Guard.tscn
        Cop.tscn

    scripts/
      player/
        player_controller.gd
        skate_state.gd
        skate_tuning.gd
        grind_detector.gd
      camera/
        cinematic_camera.gd
      missions/
        mission_controller.gd
        objective_trigger.gd
        checkpoint.gd
      gadgets/
        camcorder.gd
      interactables/
        evidence_item.gd
        interactable.gd
      enemies/
        guard_ai.gd
        detection_cone.gd
      ui/
        dialogue_box.gd
        notebook_ui.gd
      debug/
        skate_debug_overlay.gd

    assets/
      placeholder/
      sprites/
      tiles/
      audio/
      fonts/
      palettes/
```

---

## 22. Prototype Build Order

### Phase 1 — Skate Feel Sandbox

Goal:
Build movement before story.

Features:
- Player scene.
- Side-view movement.
- Push.
- Brake.
- Crouch.
- Ollie.
- Basic gravity.
- Landing.
- Bail/recover placeholder.
- Debug overlay.
- One graybox downhill route.

Acceptance:
- It is fun to skate for 60 seconds with no objective.
- Player can recover from mistakes quickly.
- Movement variables are tunable.
- Debug overlay shows state/speed/grounded.

### Phase 2 — Mercy Hill Route

Goal:
Prove safe/style/risk route structure.

Features:
- Sloped street.
- Curb gaps.
- One rail placeholder.
- One alley shortcut.
- Start checkpoint.
- Finish trigger.
- Basic camera follow.

Acceptance:
- Player can finish using safe path.
- Player can discover risky shortcut.
- Route replay is fun.
- Camera does not fight the player.

### Phase 3 — Grind and Route Mastery

Goal:
Make routes feel skate-specific.

Features:
- Grindable rail component.
- Grind detection.
- Snap tolerance.
- Grind exit.
- Landing from grind.
- Debug grind target.

Acceptance:
- Player can intentionally enter/exit grind.
- Rail behavior is readable.
- Failed grind is understandable.

### Phase 4 — Zip’s + Dialogue Hub

Goal:
Add first social/story scene.

Features:
- Zip’s exterior/interior placeholder.
- Eli, Rina, Cal, June NPC placeholders.
- Dialogue box.
- Simple branching dialogue.
- Rumor flags.
- Mission start.

Acceptance:
- Player can talk to crew.
- Dialogue advances mission.
- Rumors can set simple flags.

### Phase 5 — Camcorder Tool

Goal:
Introduce analog investigation.

Features:
- Aim/record mode.
- Evidence target.
- Capture confirmation.
- Stored evidence flag.
- Basic playback UI or cutscene trigger.

Acceptance:
- Player can record Eli’s trick.
- Game can check whether evidence was captured.
- UI communicates recording clearly.

### Phase 6 — Spillway Scene

Goal:
Build the vertical slice’s mood centerpiece.

Features:
- Large concrete canal.
- The Mouth tunnel entrance.
- Trick filming beat.
- First camcorder glitch.
- Radio tone event.
- Eli enters tunnel.

Acceptance:
- Scene feels distinct and memorable, even with placeholder art.
- Player understands The Mouth is dangerous.
- Story transitions smoothly into tunnel.

### Phase 7 — Tunnel Traversal

Goal:
Blend skating and adventure movement.

Features:
- Dismount.
- Carry board placeholder.
- Crawl/vault/climb placeholders.
- Door wedge interaction.
- Wet tunnel movement modifiers.
- Short board slope section.

Acceptance:
- Player can shift between skating and on-foot without confusion.
- Board remains central.
- Tunnel pacing feels tense.

### Phase 8 — Stealth Follow

Goal:
Introduce Northstar threat.

Features:
- Guard patrol.
- Detection cone.
- Hide zones.
- Follow objective.
- Gurney reveal.
- Photo board reveal.

Acceptance:
- Player understands line-of-sight stealth.
- Being seen can restart from checkpoint.
- Reveal lands clearly.

### Phase 9 — Tunnel Chase

Goal:
First action set piece.

Features:
- Forced escape route.
- Timed pressure.
- Obstacles.
- Flashlight cones.
- Van/headlight hazard.
- Signal distortion moments.

Acceptance:
- Chase is exciting but fair.
- No blind-fail obstacles.
- Checkpoints prevent frustration.
- Skating and cinematic tension both work.

### Phase 10 — Bedroom Playback

Goal:
End demo with story hook.

Features:
- Bedroom scene.
- TV/VCR playback.
- Damaged tape cutscene.
- Eli message.
- End card.

Acceptance:
- Player understands Eli is missing.
- Player wants to know what happened next.
- Demo has a clean endpoint.

---

## 23. Codex/Claude Working Files

### AGENTS.md

Use this in the repo root for Codex.

```md
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
4. Outsmart, Don’t Outgun
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
```

### CLAUDE.md

Use this in the repo root for Claude Code.

```md
# Signal Pines — Claude Project Context

Read `SIGNAL_PINES_DESIGN_PLAN.md` first.

This project is a Godot 4.6.x prototype for a cinematic 2.5D pixel-art skate mystery adventure.

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
```

---

## 24. Agent Skills

Create these under:

```text
.agents/skills/
```

### Skill 1: godot-2.5d-gameplay-prototyper

```md
---
name: godot-2.5d-gameplay-prototyper
description: Build or revise Godot 4.x gameplay systems for Signal Pines, especially 2.5D movement, scenes, nodes, signals, interactables, and prototype architecture.
---

# Godot 2.5D Gameplay Prototyper

You are helping build Signal Pines, a cinematic 2.5D pixel-art skate mystery adventure.

Use Godot 4.x conventions.

Priorities:
- Keep systems small and testable.
- Prefer GDScript.
- Use clear scene composition.
- Separate player movement, camera, mission logic, interactables, gadgets, and UI.
- Use placeholder assets until mechanics are proven.
- Expose tuning values in scripts/resources.
- Add comments for future extension points.

When implementing:
- Create or modify only the files needed for the task.
- Explain what changed.
- Include simple run/test instructions.
- Avoid speculative full-game systems.

Do not:
- Build a full open world.
- Add multiplayer.
- Add complex RPG systems.
- Add real-world weapon construction details.
```

### Skill 2: skate-line-controller-review

```md
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
```

### Skill 3: cinematic-pixel-art-direction

```md
---
name: cinematic-pixel-art-direction
description: Review Signal Pines visual direction, pixel-art scene composition, parallax, lighting, fog, palette, silhouettes, and cinematic readability.
---

# Cinematic Pixel Art Direction

Signal Pines should feel like 1980s Pacific Northwest pixel noir.

Priorities:
- Strong silhouettes.
- Readable routes.
- Moody lighting.
- Parallax depth.
- Wet pavement and fog.
- Analog/VHS texture.
- Clear interactable language.
- Avoid visual clutter that hides gameplay.

Scene checklist:
- Is the main route readable?
- Are hazards readable?
- Are grindable rails visually distinct?
- Are foreground/background layers separated?
- Does lighting support mood without obscuring play?
- Is the color palette disciplined?
- Does the scene feel like Cedar Rift?
- Does it avoid copying any reference too directly?

Prototype rule:
Use simple placeholder sprites first. Do not block mechanics on final art.
```

### Skill 4: vertical-slice-planner

```md
---
name: vertical-slice-planner
description: Keep Signal Pines scoped to the 10–15 minute vertical slice "The Mouth" and break large ideas into buildable tasks.
---

# Vertical Slice Planner

Current target:
Build "The Mouth" vertical slice.

Included:
- Mercy Hill skate tutorial.
- Zip’s crew scene.
- Main Street skate line.
- Spillway arrival.
- The Mouth tunnel traversal.
- Northstar stealth reveal.
- Tunnel chase.
- Eli disappearance.
- Bedroom tape playback.

Excluded for now:
- Full open world.
- Full campaign.
- Full upgrade tree.
- Multiple endings.
- Procedural generation.
- Full combat system.
- All gadgets.
- Complex NPC schedules.

For every feature request:
1. State whether it belongs in the vertical slice.
2. If yes, break it into small tasks.
3. If no, place it in the backlog.
4. Identify the acceptance criteria.
5. Identify risks and dependencies.
```

### Skill 5: narrative-mystery-designer

```md
---
name: narrative-mystery-designer
description: Design Signal Pines narrative beats, clues, rumors, VHS tapes, dialogue, character moments, and mystery structure.
---

# Narrative Mystery Designer

Tone:
- Teen adventure.
- Small-town dread.
- 1980s analog texture.
- Lab conspiracy.
- Ambiguous signal horror.
- Warmth before fear.

Core mystery:
Eli disappears after witnessing Northstar activity inside The Mouth.

Rules:
- Start grounded, then get strange.
- Do not reveal the alien/signal truth too early.
- Keep adults morally complicated.
- Let clues create questions before answers.
- Use VHS, radio, newspaper, school records, and rumors as evidence.
- Keep dialogue character-specific and concise.

Prototype narrative goal:
Make the player care about Eli before he disappears, then make the player distrust the official explanation.

Dialogue style:
- Natural teen banter.
- No lore dumps.
- Humor under pressure.
- Emotional specificity.
```

### Skill 6: 2.5d-level-design-review

```md
---
name: 2.5d-level-design-review
description: Review Signal Pines 2.5D route design, including safe/style/risk/secret paths, lane transitions, camera framing, stealth spaces, and chase readability.
---

# 2.5D Level Design Review

Every major route should include:
- Safe path.
- Style path.
- Risk path.
- Secret path.

Review for:
- Route readability.
- Fair obstacle placement.
- Clean camera framing.
- Good checkpoint placement.
- Skate-line flow.
- Foreground/background clarity.
- Secret path discoverability.
- Chase fairness.
- Stealth readability.
- Strong environmental storytelling.

Questions:
- Can a new player understand the main route?
- Can a skilled player find a better line?
- Does the level reward observation?
- Does the level support story?
- Does the level avoid dead time?
- Does the route feel like something adults would miss but kids would know?
```

---

## 25. First Prompts for Codex or Claude

### Prompt 1 — Create project skeleton

```text
Create the initial Godot 4.6.x project architecture for Signal Pines.

Use the design plan in SIGNAL_PINES_DESIGN_PLAN.md.

Goal:
Build the foundation for a 2.5D cinematic skate mystery prototype called "The Mouth."

Create:
- README.md
- GAME_BIBLE_LITE.md
- PROTOTYPE_PLAN.md
- AGENTS.md
- CLAUDE.md
- game/scenes/player/Player.tscn
- game/scripts/player/player_controller.gd
- game/scripts/player/skate_state.gd
- game/scripts/player/skate_tuning.gd
- game/scripts/camera/cinematic_camera.gd
- game/scripts/debug/skate_debug_overlay.gd

Player controller requirements:
- 2D side-view movement
- push
- brake
- crouch
- ollie
- basic slope momentum placeholder
- movement state enum
- exposed tuning values
- debug display for speed and state

Constraints:
- Use placeholder shapes/sprites only.
- Do not build combat yet.
- Do not build the full trick system yet.
- Keep code simple and readable.
- Add comments showing where grind, bail, gadgets, and animation hooks will plug in.
```

### Prompt 2 — Build Mercy Hill graybox

```text
Implement a single graybox route called Mercy Hill.

Goal:
A one-minute downhill skating route that tests movement feel.

Include:
- sloped street
- curb gaps
- one rail placeholder
- one alley shortcut
- one safe path and one risky path
- checkpoint at start
- finish trigger
- debug labels for route sections

Do not add final art.
Do not add story dialogue yet.
Focus on skating readability and feel.
```

### Prompt 3 — Add grind detection

```text
Add basic grind detection and a grind state to the player controller.

Requirements:
- detect grindable rail areas
- allow entering grind when airborne near rail and holding/pressing the grind input
- move along the rail path
- exit with jump or rail end
- expose tuning values for snap distance, grind speed, and exit force
- add debug visualization for active grind target

Keep the implementation simple and suitable for prototype tuning.
```

### Prompt 4 — Add Zip’s dialogue scene

```text
Create a simple Zip’s Diner/Arcade dialogue scene.

Goal:
Introduce Eli, Rina, Cal, and June through concise dialogue.

Include:
- placeholder NPCs
- simple interaction prompt
- dialogue box UI
- one short conversation per character
- rumor flags for The Mouth, Northstar van, curfew, and radio pulse

Do not build a full dialogue engine unless a minimal reusable structure is needed.
```

### Prompt 5 — Add camcorder evidence capture

```text
Implement a prototype camcorder evidence capture system.

Goal:
Let the player aim/record at marked evidence objects.

Include:
- camcorder mode toggle
- camera frame overlay
- evidence target component
- capture confirmation
- stored evidence flag
- debug list of captured evidence

Use it first for filming Eli’s trick at The Spillway.
```

---

## 26. Milestones

### Milestone A — Movement Proof

Deliverable:
- Player can skate in a graybox downhill scene.

Done when:
- Push/brake/crouch/ollie work.
- Slope momentum feels passable.
- Debug overlay works.
- Movement tuning values are exposed.

### Milestone B — Route Proof

Deliverable:
- Mercy Hill route with safe/risky paths.

Done when:
- Route has replay value.
- Player can finish reliably.
- Camera supports movement.
- Obstacles are readable.

### Milestone C — Skate Identity Proof

Deliverable:
- Grind, powerslide, bail/recover.

Done when:
- Player can chain basic movement.
- Failures are readable.
- Recovery is not frustrating.

### Milestone D — Story Interaction Proof

Deliverable:
- Zip’s dialogue scene.

Done when:
- Player can talk to crew.
- Rumors set flags.
- Mission can advance.

### Milestone E — Investigation Proof

Deliverable:
- Camcorder evidence capture.

Done when:
- Player can capture evidence.
- Evidence state persists in session.
- UI clearly communicates capture.

### Milestone F — Vertical Slice Assembly

Deliverable:
- The Mouth prototype end-to-end.

Done when:
- Player can start at Mercy Hill and reach ending playback scene.
- Demo has checkpoints.
- Demo has a clean end state.
- No placeholder system blocks the core fantasy.

---

## 27. Backlog

### Short-term backlog

- Better camera zones.
- Better bail animations.
- Better rail types.
- Simple NPC pathing.
- More route secrets.
- VHS playback UI.
- Night lighting pass.
- Detection meter.
- Basic sound effects.

### Mid-term backlog

- Yo-yo prototype.
- Slingshot.
- RC car.
- View-Master scanner.
- Walkie frequency puzzles.
- School hub.
- Mill route.
- Lake Mercy route.
- Reputation flags.
- Notebook UI.

### Long-term backlog

- Full campaign.
- Multiple districts.
- Day/night variations.
- Curfew system.
- Faction reputation.
- Gear upgrades.
- Advanced tricks.
- Signal zones.
- Alternate endings.

---

## 28. Risk Register

### Risk 1 — Skating does not feel good

Severity:
Critical.

Mitigation:
Build movement sandbox first. Do not build story or art until movement is fun.

### Risk 2 — Pixel art quality becomes a bottleneck

Severity:
High.

Mitigation:
Use placeholders and mood-blocking first. Establish strong composition before final sprite production.

### Risk 3 — Scope creep

Severity:
Critical.

Mitigation:
Every feature must support The Mouth vertical slice or go to backlog.

### Risk 4 — 2.5D lane movement becomes confusing

Severity:
Medium.

Mitigation:
Use authored transitions, not free-depth movement at first.

### Risk 5 — Combat dilutes the mystery

Severity:
Medium.

Mitigation:
Combat remains light, evasive, and tool-based. Avoid soldier fantasy.

### Risk 6 — Story becomes too supernatural too soon

Severity:
Medium.

Mitigation:
Start with missing friend and lab conspiracy. Let alien/signal angle emerge slowly.

### Risk 7 — Agent-generated code becomes messy

Severity:
High.

Mitigation:
Use AGENTS.md, skills, small prompts, and frequent review/refactor checkpoints.

---

## 29. Definition of Done for the First Public Prototype

The first public prototype is done when:

1. The player can complete a 10–15 minute demo.
2. Skating feels good enough to replay without story.
3. The route structure shows safe/style/risk/secret thinking.
4. The player meets Eli and cares when he disappears.
5. The camcorder captures at least one meaningful clue.
6. The Northstar reveal is clear.
7. The tunnel chase is playable and fair.
8. The ending tape hook lands.
9. Placeholder art communicates the intended mood.
10. The build can be run by someone else with clear instructions.

---

## 30. One-Sentence Creative North Star

**Signal Pines is about kids using movement, friendship, analog tools, and forbidden routes to uncover the adult world’s hidden map.**
