extends Area3D

@export var force_direction: Vector3 = Vector3(0, 0, 1)

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			body.global_position = body.global_position + force_direction * delta
