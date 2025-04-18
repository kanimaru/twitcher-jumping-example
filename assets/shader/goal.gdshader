shader_type canvas_item;

uniform vec4 color: source_color;
uniform float scale = 1.0;
uniform sampler2D noise;

vec2 toPolar(vec2 cartesian){
	float dist = length(cartesian);
	float angle = atan(cartesian.y, cartesian.x);
	return vec2(angle / TAU, dist);
}

void fragment() {
	vec4 _out_color = vec4(0,0,0,1);
	vec2 _uv = UV - vec2(.5);
	vec2 _uv_pol = toPolar((UV - vec2(.5)) / sin(TIME));
	

	float norm_time = sin(TIME) + 1.0 / 2.0;

	float dist = 1.0 - distance(vec2(0), _uv);
	float rays = 5.0;
	float radius = 0.2;
	float angle = atan(UV.y - .5, UV.x - .5);
	float thickness = .5;
	float speed = .5;
	float border = .0;
	
	//float opening = 1.0 - norm_time * .6;
	
	vec4 _noise = texture(noise, fract(UV + TIME * speed));
	border = smoothstep(.0, 1.0, dist) + _noise.x;
	
	_out_color = (1. - smoothstep(-0.1, .1, fract(2.0 * radius - (angle + PI + dist*5.0) / TAU * rays + -TIME * speed) - thickness)) * color;
	_out_color.a = (1. - pow(smoothstep(1.0, .5, dist), 8.0)) * pow(border, 4.0);
	//_out_color.b = border;
	COLOR = _out_color;
}
