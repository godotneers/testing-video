shader_type spatial;

global uniform vec3 player_pos;

varying vec3 world_vertex;
uniform float sphere_size = 3.0;

void vertex() {
	world_vertex = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}


void fragment() {
	float dist = min(distance(player_pos, world_vertex), sphere_size);
	ALPHA = dist/sphere_size;
}
