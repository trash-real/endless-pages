shader_type canvas_item;

uniform float line_density : hint_range(50.0, 300.0, 10.0) = 100.0;
uniform float line_opacity : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float line_thickness : hint_range(0.1, 0.9, 0.05) = 0.5;
uniform bool enable_flicker = false;
uniform float flicker_speed : hint_range(0.1, 10.0, 0.1) = 5.0;
uniform float flicker_intensity : hint_range(0.0, 0.1, 0.01) = 0.02;

void fragment() {
    float scanline_position = UV.y * line_density;
    float scanline = fract(scanline_position);
    scanline = step(line_thickness, scanline);

    float flicker_amount = 0.0;
    if (enable_flicker) {
        flicker_amount = sin(TIME * flicker_speed + scanline_position) * flicker_intensity;
    }

    float darkness = mix(0.0, 1.0, scanline);
    darkness += flicker_amount;

    COLOR = vec4(0.0, 0.0, 0.0, line_opacity / 3.0 * (1.0 - darkness));
}