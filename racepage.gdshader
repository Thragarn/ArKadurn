shader_type canvas_item;

// This exposes a slot in your inspector to drop your stamp texture into!
uniform sampler2D mask_texture : filter_nearest;

// New: lets code fade the portrait in/out directly, since node modulate
// gets overridden by this shader's custom COLOR output.
uniform float alpha_multiplier : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	// Get the pixel color of the current character portrait
	vec4 tex_color = texture(TEXTURE, UV);
	// Get the pixel color of your white arch mask stamp
	vec4 mask_color = texture(mask_texture, UV);
	// Multiply the portrait's alpha by the mask's alpha channel, then by our fade value
	tex_color.a *= mask_color.a * alpha_multiplier;
	// Output the perfectly masked, fadeable portrait pixel
	COLOR = tex_color;
}