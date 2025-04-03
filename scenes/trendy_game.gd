extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var godot_plush = $"Godot Plush"

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.camera_mount.rotation.x = deg_to_rad(-30)
	#player.enable_jumping = false
	player.enable_kicking = false
	player.lock_camera = true

	# Spawn 100 plushies
	#spawn_plushies(222)

## Spawns the specified number of plushies in random positions
func spawn_plushies(count: int) -> void:
	# Get the original plush position to use as a reference
	var original_pos = godot_plush.global_position
	
	# Define the spawn area (adjust these values based on your scene)
	var spawn_range_x = 2.0
	var spawn_range_z = 2.0
	var height_variation = 2.0
	
	# Create the plushies
	for i in range(count):
		# Create a duplicate of the original plush
		var new_plush = godot_plush.duplicate()
		
		# Generate a random position
		var random_x = original_pos.x + randf_range(-spawn_range_x, spawn_range_x)
		var random_y = original_pos.y + randf_range(0, height_variation)
		var random_z = original_pos.z + randf_range(-spawn_range_z, spawn_range_z)
		
		# Set the position
		new_plush.global_position = Vector3(random_x, random_y, random_z)
		
		# Add random rotation for variety
		new_plush.rotation = Vector3(
			randf_range(0, TAU),  # Random rotation around X axis
			randf_range(0, TAU),  # Random rotation around Y axis
			randf_range(0, TAU)   # Random rotation around Z axis
		)
		
		# Add a small random scale variation
		var scale_factor = randf_range(0.8, 1.2)
		new_plush.scale = Vector3(scale_factor, scale_factor, scale_factor)
		
		# Add the new plush to the scene
		add_child(new_plush)
