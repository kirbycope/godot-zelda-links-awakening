extends Node3D

@onready var crane: Node3D = $Crane
@onready var crane_animation_player: AnimationPlayer = $Crane/Armature/AnimationPlayer
@onready var dialogue: Control = $Player/CameraMount/Camera3D/Dialogue
@onready var dialogue_text: Control = $Player/CameraMount/Camera3D/Dialogue/Body/Text
@onready var godot_plush = $GodotPlush
@onready var player: CharacterBody3D = $Player
@onready var player_animation_player: AnimationPlayer = $Player/Visuals/AuxScene/AnimationPlayer
@onready var railing_animation_player: AnimationPlayer = $Railing/AnimationPlayer

var crane_locked := false
var crane_starting_position: Vector3
var is_playing := false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and is_playing:
		stop()


func _process(delta: float) -> void:
	if is_playing and crane_locked != true:
		if Input.is_action_pressed("move_up"):
			crane.global_position.z -= delta * 1.5
		elif Input.is_action_pressed("move_down"):
			crane.global_position.z += delta * 1.5
		elif Input.is_action_pressed("move_left"):
			crane.global_position.x -= delta * 1.5
		elif Input.is_action_pressed("move_right"):
			crane.global_position.x += delta * 1.5
		elif Input.is_action_pressed("jump"):
			crane_locked = true
			var new_position = Vector3(crane.global_position.x, crane.global_position.y - 1.2, crane.global_position.z)
			var tween = player.get_tree().create_tween()
			tween.tween_property(crane, "global_position", new_position, 1.0)
			await get_tree().create_timer(1.0).timeout
			crane_animation_player.play_backwards("open")
			await get_tree().create_timer(1.0).timeout
			var tween2 = player.get_tree().create_tween()
			# ToDo: Make so that it takes longer to return the further from crane_starting_position
			tween2.tween_property(crane, "global_position", crane_starting_position, 2.0)
			await get_tree().create_timer(2.0).timeout
			crane_animation_player.play("open")
			dialogue_text.text = "Challenge again?"
			dialogue.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crane_starting_position = crane.global_position
	player.camera_mount.rotation.x = deg_to_rad(-30)
	player.enable_jumping = false
	player.enable_kicking = false
	player.lock_camera = true
	dialogue.hide()

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


## Called when a body enters the Area3D (in front of the button console).
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_animation_player.stop()
		dialogue_text.text = "TRENDY GAME! One play 10 rupees."
		dialogue.show()
		player.game_paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


## Called when a body exits the Area3D (in front of the button console).
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		dialogue.hide()


func start() -> void:
	if not is_playing:
		crane_locked = false
		crane_animation_player.play("open")
		railing_animation_player.play("raise")
	is_playing = true
	player.game_paused = true


func stop() -> void:
	crane_animation_player.play_backwards("open")
	railing_animation_player.play_backwards("raise")
	is_playing = false
	var tween = player.get_tree().create_tween()
	tween.tween_property(crane, "global_position", crane_starting_position, 1.0)
