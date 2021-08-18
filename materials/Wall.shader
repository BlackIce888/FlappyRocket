shader_type canvas_item;

float rand(float i) {
	return mod(4000.*sin(23464.345*i+45.345),1.);
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	vec3 col = cos(rand(2) * TIME + UV.xyx + vec3(0,2,4));
	
	color.rgb = col;
	COLOR = color;
	
}