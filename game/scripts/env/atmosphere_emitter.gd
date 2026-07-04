class_name AtmosphereEmitter
extends Resource
## One ambient particle field in an AtmosphereConfig. Presets map to CPUParticles2D
## configs (GPU particles are avoided on this project's gl_compatibility renderer).

enum Preset { DUST, MIST, EMBERS, RAIN, LEAVES, DRIP }

@export var preset: Preset = Preset.DUST
## Spawn region, centered on `region_center`, in world px.
@export var region_center := Vector2(1500, 0)
@export var region_size := Vector2(3000, 600)
@export var amount := 40
@export var tint := Color(1, 1, 1, 0.5)
@export var z_index := 6
