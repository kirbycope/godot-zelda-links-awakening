extends Node3D

var material_a: ShaderMaterial
var material_x: ShaderMaterial


## Called when the node is "ready", i.e. when both the node and its children have entered the scene tree.
func _ready():
	material_a = $CraneGameButton/Skeleton3D/button_A__MI_ControlPanel_A.get_surface_override_material(0)
	material_x = $CraneGameButton/Skeleton3D/button_X__MI_ControlPanel_X.get_surface_override_material(0)


# Function to turn the effect on
func enable_highlight_effect():
	material_a.set_shader_parameter("effect_enabled", true)
	material_x.set_shader_parameter("effect_enabled", true)


# Function to turn the effect off
func disable_highlight_effect():
	material_a.set_shader_parameter("effect_enabled", false)
	material_x.set_shader_parameter("effect_enabled", false)


# Function to toggle the effect on/off
func toggle_highlight_effect():
	var current_state_a = material_a.get_shader_parameter("effect_enabled")
	material_a.set_shader_parameter("effect_enabled", !current_state_a)
	var current_state_x = material_x.get_shader_parameter("effect_enabled")
	material_x.set_shader_parameter("effect_enabled", !current_state_x)
