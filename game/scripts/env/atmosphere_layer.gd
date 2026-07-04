class_name AtmosphereLayer
extends Resource
## One parallax (or occluder) layer in an AtmosphereConfig. Either supply a
## `texture` (drawn as a Sprite2D — this is where AI sprites land) or a
## `proc_kind` (drawn procedurally as polygons until real art exists). A layer
## with neither is skipped.

enum Kind { NONE, SKY, HILLS, TREELINE, BUILDINGS, POLES, HAZE, BRICKWALL, PIPES, VINES }

## When set, the layer renders this texture and ignores proc_kind.
@export var texture: Texture2D
## Procedural fallback shape, used when texture is null.
@export var proc_kind: Kind = Kind.NONE
## Parallax factor: <1 = behind/slower (depth), >1 = foreground occluder.
@export var scroll_scale := Vector2(0.5, 1.0)
## Horizontal repeat span in px (0 = no repeat). Tiles the layer for long routes.
@export var repeat_size := 0.0
@export var z_index := -15
## World-space offset of the layer's anchor from the route origin.
@export var offset := Vector2.ZERO
@export var tint := Color.WHITE
## Procedural layers: primary + secondary silhouette colors and vertical span.
@export var proc_color := Color(0.1, 0.12, 0.14)
@export var proc_color_alt := Color(0.14, 0.16, 0.2)
@export var proc_base_y := 0.0
@export var proc_span := 1800.0
@export var proc_seed := 0
