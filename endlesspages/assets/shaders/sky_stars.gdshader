shader_type sky;

uniform int vertical_sections = 21;
uniform float star_size = 0.02;
uniform float star_falloff = 4.;
uniform float margin = 0.05;

// Rotation
uniform vec3 rotation_axis = vec3(0.0, 1.0, 0.0);
uniform float rotation_angle = 0.0;
uniform float rotation_speed = 0.0;

// Horizon cutoff
uniform float horizon_angle = 0.0;
uniform float horizon_fade : hint_range(0.01, 20.0) = 2.0;

mat3 axis_angle(vec3 axis, float angle)
{
	vec3 a = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat3(
		vec3(oc * a.x * a.x + c,       oc * a.x * a.y + a.z * s, oc * a.z * a.x - a.y * s),
		vec3(oc * a.x * a.y - a.z * s, oc * a.y * a.y + c,       oc * a.y * a.z + a.x * s),
		vec3(oc * a.z * a.x + a.y * s, oc * a.y * a.z - a.x * s, oc * a.z * a.z + c)
	);
}

vec2 dir_to_sky_coords(vec3 dir)
{
	float u = atan(dir.x, -dir.z) / (2.0 * PI) + 0.5;
	float v = asin(clamp(dir.y, -1.0, 1.0)) / PI + 0.5;
	return vec2(u, v);
}

vec2 get_partition(vec2 sky_coords)
{
	float y = sky_coords.y * 2. - 1.;
	float section_y = ceil(abs(y) * float(vertical_sections)) / float(vertical_sections);
	float horizontal_sections = max(4., ceil(float(vertical_sections) * 4. * cos(section_y * PI / 2.)));
	horizontal_sections = horizontal_sections > 0. ? horizontal_sections : 1.;
	return vec2(sky_coords.x * horizontal_sections, y * float(vertical_sections));
}

vec2 rand_vec2(vec2 xy)
{
	float rand1 = fract(sin(dot(xy, vec2(11.9131, 81.2317))) *  57183.77193);
	float rand2 = fract(sin(dot(xy, vec2(16.8131, 91.2327))) *  37113.66193);
	return vec2(rand1, rand2) * ( 1. - margin * 2.) + margin;
}

float star_brightness(vec2 sky_coords)
{
	vec2 partitions = get_partition(sky_coords);
	vec2 partition_index = floor(partitions);
	vec2 inner_coord = fract(partitions);
	vec2 star_coord = rand_vec2(partition_index);
	float dist = length(inner_coord - star_coord);
	return pow(star_size / dist, star_falloff);
}

void sky()
{
	float angle = radians(rotation_angle + TIME * rotation_speed);
	vec3 star_dir = axis_angle(rotation_axis, angle) * EYEDIR;
	float stars = star_brightness(dir_to_sky_coords(star_dir));
	
	float cutoff_start = sin(radians(horizon_angle));
	float cutoff_end = sin(radians(horizon_angle + horizon_fade));
	float mask = smoothstep(cutoff_start, cutoff_end, EYEDIR.y);
	
	COLOR = AT_CUBEMAP_PASS ? vec3(0.0) : vec3(stars * mask);
}