extends Node3D

@onready var buttons: Node3D = $Buttons
@onready var buttons_position: MeshInstance3D = $ButtonsPosition
@onready var crane: Node3D = $Crane
@onready var crane_animation_player: AnimationPlayer = $Crane/Armature/AnimationPlayer
@onready var crane_ray_cast_3d: RayCast3D = $Crane/RayCast3D
@onready var dialogue: Control = $Player/CameraMount/Camera3D/Dialogue
@onready var dialogue_text: Control = $Player/CameraMount/Camera3D/Dialogue/Body/Text
@onready var godot_plush = $Prizes/GodotPlush
@onready var player: CharacterBody3D = $Player
@onready var player_animation_player: AnimationPlayer = $Player/Visuals/AuxScene/AnimationPlayer
@onready var railing_animation_player: AnimationPlayer = $Railing/AnimationPlayer
var crane_locked := false
var crane_starting_position: Vector3
var is_playing := false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and is_playing and not crane_locked:
		stop()
	if dialogue.visible and not is_playing:
		if Input.is_action_just_pressed("start"):
			dialogue._on_pass_pressed()


func _process(delta: float) -> void:
	if is_playing and not crane_locked:
		if Input.is_action_pressed("move_up"):
			crane.global_position.z -= delta * 1.5
		elif Input.is_action_pressed("move_down"):
			crane.global_position.z += delta * 1.5
		elif Input.is_action_pressed("move_left"):
			crane.global_position.x -= delta * 1.5
		elif Input.is_action_pressed("move_right"):
			crane.global_position.x += delta * 1.5
		elif Input.is_action_pressed("jump") and crane.global_position != crane_starting_position:
			# Stop the crane
			buttons.disable_highlight_effect()
			crane_locked = true
			# Get the collision point
			var collision_point = crane_ray_cast_3d.get_collision_point()
			var offset =  crane_ray_cast_3d.global_position.y - collision_point.y
			# Lower crane
			var new_position = Vector3(crane.global_position.x, crane.global_position.y - offset, crane.global_position.z)
			var tween = player.get_tree().create_tween()
			tween.tween_property(crane, "global_position", new_position, 1.0)
			await get_tree().create_timer(1.0).timeout # Wait for tween to finish
			# Close claw
			crane_animation_player.play_backwards("open")
			await get_tree().create_timer(1.0).timeout # Wait for animation to finish
			# Raise crane
			var tween2 = player.get_tree().create_tween()
			new_position = Vector3(crane.global_position.x, crane.global_position.y + 1.2, crane.global_position.z)
			tween2.tween_property(crane, "global_position", new_position, 1.0)
			await get_tree().create_timer(1.0).timeout # Wait for tween to finish
			# Return crane to starting position
			var tween3 = player.get_tree().create_tween()
			var distance = crane.global_position.distance_to(crane_starting_position)
			var return_time = clamp(distance * 0.8, 2.0, 5.0)
			tween3.tween_property(crane, "global_position", crane_starting_position, return_time)
			await get_tree().create_timer(return_time).timeout # Wait for tween to finish
			crane_animation_player.play("open")
			await get_tree().create_timer(2.0).timeout # Wait for animation to finish
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


## Called when a body enters the Area3D (in front of the button console).
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		player_animation_player.stop()
		dialogue_text.text = "TRENDY GAME! One play 10 rupees."
		dialogue.show()
		player.game_paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var tween = player.get_tree().create_tween()
		tween.parallel().tween_property(player, "global_transform", buttons_position.global_transform, 0.2)
		tween.parallel().tween_property(player.visuals, "global_transform", buttons_position.global_transform, 0.2)


## Called when a body exits the Area3D (in front of the button console).
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		dialogue.hide()


func start() -> void:
	if not is_playing:
		crane_animation_player.play("open")
		railing_animation_player.play("raise")
	buttons.enable_highlight_effect()
	crane_locked = false
	is_playing = true
	player.game_paused = true


func stop() -> void:
	buttons.disable_highlight_effect()
	crane_animation_player.play_backwards("open")
	railing_animation_player.play_backwards("raise")
	is_playing = false
	var tween = player.get_tree().create_tween()
	tween.tween_property(crane, "global_position", crane_starting_position, 1.0)
