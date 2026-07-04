shader_type canvas_item;

// Pass the player's global position from GDScript
uniform vec2 player_position;
uniform float cut_radius = 64.0;
uniform float feather = 32.0;

// This variable securely carries world data from vertex -> fragment
varying vec2 world_pos;

void vertex() {
	// Calculate the exact world space coordinates by using the MODEL_MATRIX
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// 1. Calculate how far this specific tile pixel is from the player
	float dist = distance(world_pos, player_position);
	
	// 2. Create our smooth mask circle
	float mask = smoothstep(cut_radius, cut_radius + feather, dist);
	
	// 3. Apply the transparency drop directly onto the texture map
	vec4 tex_color = texture(TEXTURE, UV);
	tex_color.a *= mask;
	
	COLOR = tex_color;
}