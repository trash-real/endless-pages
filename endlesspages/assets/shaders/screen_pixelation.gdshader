// Pixelate (halftone variant)
// Screen-space pixelation with optional colour steps and halftone dithering.
// Godot 4.7 · CC0 1.0 · based on godotlearning.com/shaders/pixelate
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
// Halftone dithering before the levels are applied, so gradients turn into dots
// that grow and shrink instead of hard bands. No effect while palette_steps is 0.
uniform bool dither = false;
// Distance between neighbouring dots, in blocks (not screen pixels), so the dots
// are built out of the same blocks as the rest of the image.
uniform float halftone_size : hint_range(2.0, 16.0, 0.5) = 4.0;
// Rotation of the dot grid in degrees. 45 is the classic print angle and hides
// the grid best; 0 lines the dots up with the blocks.
uniform float halftone_angle : hint_range(0.0, 90.0, 0.5) = 45.0;

// Rounding threshold for a block, from its position in the rotated dot grid.
// Close to 1 at the centre of each dot and close to 0 midway between four dots,
// so as a colour gets brighter a light dot grows from each centre until only a
// dark dot is left in each gap. Kept inside 0.02..0.98 so a colour that already
// sits exactly on a level never gets pushed off it.
float halftone_threshold(vec2 block) {
	float angle = radians(halftone_angle);
	float c = cos(angle);
	float s = sin(angle);
	// Block centre, rotated, then measured in dot spacings.
	vec2 p = mat2(vec2(c, -s), vec2(s, c)) * (block + 0.5) / halftone_size;
	return 0.5 + 0.24 * (cos(TAU * p.x) + cos(TAU * p.y));
}

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
		// With it, each block rounds at the threshold the dot pattern gives it.
		float threshold = 0.5;
		if (dither) {
			threshold = halftone_threshold(block);
		}
		rgb = clamp(floor(rgb * steps + threshold) / steps, 0.0, 1.0);
	}
	COLOR = vec4(rgb, 1.0);
}