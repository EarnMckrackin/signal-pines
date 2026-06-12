class_name SkateState
extends RefCounted
## Movement state ids shared by the player controller and debug tooling.

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
	CRAWLING,
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
	CRAWLING: "Crawling",
	INTERACTING: "Interacting",
}
