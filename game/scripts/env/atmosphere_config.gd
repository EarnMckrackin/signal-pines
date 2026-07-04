class_name AtmosphereConfig
extends Resource
## The art-direction "tuning resource" for a route's environment — the
## environment's answer to SkateTuning. Holds the palette, parallax layers,
## particle fields, and grade for one route. Assign one to an Atmosphere node.
## Saveable as .tres; for now routes build these in code via RoutePalettes.

@export var display_name := ""
## Sky gradient, painted on a static far layer behind all parallax.
@export var sky_top := Color(0.09, 0.08, 0.17)
@export var sky_bottom := Color(0.2, 0.18, 0.26)
## Overall color grade (CanvasModulate). White = no grade.
@export var grade := Color.WHITE
@export var layers: Array[AtmosphereLayer] = []
@export var emitters: Array[AtmosphereEmitter] = []
@export var occluders: Array[AtmosphereLayer] = []
## Screen-space film grain strength (0 = off). ~0.05 reads as VHS-adjacent air.
@export var grain := 0.0
## Screen-edge vignette strength (0 = off). Frames the route cinematically.
@export var vignette := 0.0
