shader_type canvas_item;
// Screen-space film grain + vignette, drawn on a full-rect ColorRect in a
// high CanvasLayer. Both strengths come from AtmosphereConfig; either at 0.0
// disables that component. Cheap enough for gl_compatibility.

uniform float grain_amount : hint_range(0.0, 0.3) = 0.06;
uniform float grain_fps = 18.0;
uniform float vignette_amount : hint_range(0.0, 1.0) = 0.3;

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	float t = floor(TIME * grain_fps);
	float g = rand(SCREEN_UV * vec2(917.3, 533.7) + vec2(t * 0.013, t * 0.029));
	float grain_a = grain_amount * abs(g - 0.5) * 2.0;

	float d = distance(SCREEN_UV, vec2(0.5));
	float vig_a = vignette_amount * smoothstep(0.42, 0.92, d);

	COLOR.rgb = mix(vec3(g), vec3(0.02, 0.02, 0.05), vig_a / max(vig_a + grain_a, 0.001));
	COLOR.a = clamp(grain_a + vig_a, 0.0, 1.0);
}
