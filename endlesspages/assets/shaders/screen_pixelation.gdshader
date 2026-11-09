// Pixelate
// Screen-space pixelation with optional colour steps and ordered dithering.
// Godot 4.7 · CC0 1.0 · godotlearning.com/shaders/pixelate
shader_type canvas_item;
// No 2D lights on the effect itself: it shows the screen exactly as it was drawn.
render_mode unshaded;
 
// Everything drawn on screen before this node. filter_nearest makes each block
// copy one screen pixel exactly. repeat_disable clamps samples past the right or
// bottom edge to the last pixel instead of wrapping round to the other side.
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest, repeat_disable;
 
// Width and height of one block, in pixels of the viewport this node draws into.
// 1 leaves the image as it is.
uniform float pixel_size : hint_range(1, 32) = 1.0;
// Levels per colour channel. 0 keeps every colour. 2 to 16 limits red, green and
// blue to that many levels each (4 gives 4 x 4 x 4 = 64 colours). 1 counts as 2.
uniform int palette_steps : hint_range(0, 16) = 0;
// Ordered (Bayer 4x4) dithering before the levels are applied, so gradients turn
// into a fixed pattern of blocks instead of hard bands. No effect while
// palette_steps is 0.
uniform bool dither = false;
 
// The 4x4 Bayer matrix: every value from 0 to 15 once, spread so that each
// threshold sits as far as possible from the ones close to it.
const float BAYER[16] = float[16](
	0.0, 8.0, 2.0, 10.0,
	12.0, 4.0, 14.0, 6.0,
	3.0, 11.0, 1.0, 9.0,
	15.0, 7.0, 13.0, 5.0
);
 
void fragment() {
	float size = float(pixel_size);
	// The block this pixel belongs to, counted from the top-left of the viewport.
	vec2 block = floor(FRAGCOORD.xy / size);
	// Every pixel of the block reads the same screen pixel: the one at the block's
	// centre. Sampling the middle of that pixel, not the line between two pixels
	// (where an even block size puts its centre), gives the same answer on every GPU.
	vec2 centre_pixel = floor((block + 0.5) * size);
	vec2 uv = (centre_pixel + 0.5) * SCREEN_PIXEL_SIZE;
	vec3 rgb = textureLod(screen_texture, uv, 0.0).rgb;
 
	if (palette_steps > 0) {
		float steps = float(max(palette_steps, 2) - 1);
		// Without dithering every value rounds to the nearest level (threshold 0.5).
		// With it, each block in a 4x4 group rounds at its own threshold.
		float threshold = 0.5;
		if (dither) {
			ivec2 cell = ivec2(mod(block, 4.0));
			threshold = (BAYER[cell.y * 4 + cell.x] + 0.5) / 16.0;
		}
		rgb = clamp(floor(rgb * steps + threshold) / steps, 0.0, 1.0);
	}
	COLOR = vec4(rgb, 1.0);
}