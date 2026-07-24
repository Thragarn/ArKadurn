shader_type canvas_item;

// This exposes a slot in your inspector to drop your stamp texture into!
uniform sampler2D mask_texture : filter_nearest;

void fragment() {
    // Get the pixel color of the current character portrait
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Get the pixel color of your white arch mask stamp
    vec4 mask_color = texture(mask_texture, UV);
    
    // Multiply the portrait's alpha by the mask's alpha channel
    tex_color.a *= mask_color.a;
    
    // Output the perfectly masked portrait pixel
    COLOR = tex_color;
}