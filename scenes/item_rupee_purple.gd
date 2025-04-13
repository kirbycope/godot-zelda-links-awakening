extends RigidBody3D

@onready var effects = $"../../Effects"
var fanfare = preload("res://assets/sounds/key_item_fanfare.ogg")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.is_animation_locked = true
		body.animation_player.play("fanfare")
		effects.stream = fanfare
		effects.play()
		freeze = true
		position = body.position + Vector3(0.0, 2.0, 0.0)
		rotation = Vector3.ZERO
		# Delay execution
		await get_tree().create_timer(3.0).timeout
		queue_free()
