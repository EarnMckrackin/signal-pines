class_name SkateTuning
extends Resource
## Every feel-critical number for the skate controller lives here so tuning
## sessions never touch movement logic. Save variants as .tres to A/B feels.

@export_group("Push")
@export var push_impulse := 150.0
@export var push_interval := 0.35
@export var max_push_speed := 540.0
@export var absolute_max_speed := 950.0
@export var lean_accel := 170.0

@export_group("Friction")
@export var ground_friction := 55.0
@export var brake_friction := 950.0
@export var powerslide_friction := 430.0
@export var air_drag := 12.0

@export_group("Slope")
## How strongly gravity converts into speed along the surface (1.0 = full).
@export var slope_grip := 0.85

@export_group("Ollie")
@export var gravity := 1700.0
@export var max_fall_speed := 1500.0
@export var ollie_force_min := 380.0
@export var ollie_force_max := 640.0
@export var crouch_charge_time := 0.45
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12
@export var air_control := 650.0

@export_group("Powerslide")
@export var powerslide_min_speed := 220.0

@export_group("Bail")
## Hitting a wall faster than this triggers a bail instead of a stop.
@export var bail_impact_speed := 430.0
@export var bail_duration := 0.55
@export var recover_duration := 0.3

@export_group("On Foot")
@export var walk_speed := 190.0
@export var walk_accel := 1500.0
@export var foot_jump_force := 430.0
