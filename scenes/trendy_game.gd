extends Node3D

@onready var player: CharacterBody3D = $Player


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.camera_mount.rotation.x = deg_to_rad(-30)
	player.enable_jumping = false
	player.enable_kicking = false
	player.lock_camera = true
