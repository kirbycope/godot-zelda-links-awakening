shader_type spatial;

// Parameters that can be adjusted from Godot's inspector
uniform sampler2D albedo_texture : source_color;
uniform float speed : hint_range(0.0, 20.0) = 5.0;
uniform vec3 direction = vec3(0.0, 0.0, 1.0);
uniform float texture_scale : hint_range(0.1, 10.0) = 1.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.2;

void vertex() {
    // No vertex manipulation needed for basic UV scrolling
}

void fragment() {
    // Calculate the animated UVs based on time
    vec2 base_uv = UV * texture_scale;
    
    // Only animate along the Y-direction (assuming this is the belt's length)
    // Adjust this if your belt's orientation is different
    vec2 uv_offset = vec2(0.0, TIME * speed * 0.05);
    
    // Apply the offset to the UVs
    vec2 final_uv = base_uv - uv_offset;
    
    // Sample the albedo texture with the animated UVs
    vec4 albedo = texture(albedo_texture, final_uv);
    
    // Output the color and material properties
    ALBEDO = albedo.rgb;
    ROUGHNESS = roughness;
}