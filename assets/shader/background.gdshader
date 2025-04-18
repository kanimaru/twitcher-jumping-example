shader_type canvas_item;

uniform float stripe_amount = 5.0;
uniform float speed = .05;
uniform float rotation = 30.0;

vec2 rotateUV(vec2 uv, float rot_rad, vec2 mid)
{
    return vec2(
      cos(rot_rad) * (uv.x - mid.x) + sin(rot_rad) * (uv.y - mid.y) + mid.x,
      cos(rot_rad) * (uv.y - mid.y) - sin(rot_rad) * (uv.x - mid.x) + mid.y
    );
}

void fragment() {
	vec4 _out_color = vec4(0,0,0,1);
	vec2 _uv = UV;
	
	
	float rot_rad = radians(rotation);
	_uv = rotateUV(_uv, rot_rad, vec2(.5));
	
	_uv.x = fract(TIME * speed + _uv.x);
	
	float stripe = mod(_uv.x * stripe_amount, 1.0);
	stripe = step(.5, stripe);
	vec4 color1 = texture(TEXTURE, vec2(0.0));
	vec4 color2 = texture(TEXTURE, vec2(1.0));
	_out_color = stripe == 1.0 ? color1 : color2;
	
	COLOR = _out_color;
}
