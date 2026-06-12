class_name SkateState
extends RefCounted
## Movement state ids shared by the player controller and debug tooling.
## Later phases plug in here: GRINDING (Phase 3), CLIMBING/INTERACTING (Phase 7+).

enum {
	ON_FOOT,
	SKATING,
	CROUCHING,
	AIRBORNE,
	POWERSLIDING,
	BAILING,
	RECOVERING,
	GRINDING,
	MOUNTING,
	CLIMBING,
	INTERACTING,
}

const NAMES := {
	ON_FOOT: "OnFoot",
	SKATING: "Skating",
	CROUCHING: "Crouching",
	AIRBORNE: "Airborne",
	POWERSLIDING: "Powersliding",
	BAILING: "Bailing",
	RECOVERING: "Recovering",
	GRINDING: "Grinding",
	MOUNTING: "Mounting",
	CLIMBING: "Climbing",
	INTERACTING: "Interacting",
}
