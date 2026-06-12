class_name SkateTuning
extends Resource
## Every feel-critical number for the skate controller lives here so tuning
## sessions never touch movement logic. Save variants as .tres to A/B feels.

@export_group("Push")
## One kick per button press (EA Skate style), so each tap counts for more.
@export var push_impulse := 185.0
@export var push_interval := 0.3
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

@export_group("Grind")
## How close (px) the board must be to a rail to snap on while holding brake.
@export var grind_snap_distance := 34.0
## Fraction of the along-rail velocity kept when snapping onto the rail.
@export var grind_entry_retention := 0.9
## Speed decay along the rail (px/s^2). Lower than ground_friction so rails
## read as the fast line; slope gravity still applies on angled rails.
@export var grind_friction := 30.0
## Upward pop when ollieing out of a grind.
@export var grind_exit_force := 430.0
## Lockout after leaving a rail before it can be grabbed again, so the exit
## pop does not immediately re-snap.
@export var grind_regrab_time := 0.25
## Player origin height above the rail line while grinding (board contact).
@export var grind_ride_height := 27.0

@export_group("Bail")
## Hitting a wall faster than this triggers a bail instead of a stop.
@export var bail_impact_speed := 430.0
@export var bail_duration := 0.55
@export var recover_duration := 0.3

@export_group("On Foot")
@export var walk_speed := 220.0
@export var walk_accel := 1500.0
@export var foot_jump_force := 430.0
