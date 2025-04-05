shader_type spatial;

// Adjust these parameters to control the effect
uniform float speed = 1.0;  // Controls how fast the brightness cycles
uniform float min_brightness = 0.5;  // Minimum brightness
uniform float max_brightness = 1.5;  // Maximum brightness
uniform bool effect_enabled = false;  // Toggle to enable/disable the effect
uniform sampler2D albedo_texture : source_color;  // The texture input

void fragment() {
    // Get the base color from the texture
    vec4 base_color = texture(albedo_texture, UV);
    
    if (effect_enabled) {
        // Only calculate and apply the brightness effect when enabled
        float brightness = mix(
            min_brightness, 
            max_brightness, 
            (sin(TIME * speed) + 1.0) / 2.0
        );
        
        // Apply brightness to the color
        ALBEDO = base_color.rgb * brightness;
    } else {
        // When disabled, just use the original color
        ALBEDO = base_color.rgb;
    }
    
    // Maintain the original alpha value
    ALPHA = base_color.a;
}