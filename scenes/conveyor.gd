extends Area3D

var _bodies_on_belt = []
@export var speed = 1.0
@export var direction = Vector3(0, 0, 1)
@export var force_multiplier = 4.0 

func _physics_process(delta):
	# Apply force to all bodies on the belt
	for body in _bodies_on_belt:
		if body is RigidBody3D:
			# For rigid bodies, apply a stronger continuous force
			body.apply_central_force(direction.normalized() * speed * force_multiplier)
			# Apply additional torque if object is not moving as expected
			var velocity_diff = direction.normalized() * speed - body.linear_velocity
			if velocity_diff.length() > 1.0:
				# Apply additional force in direction of intended movement
				body.apply_central_force(velocity_diff * 2.0)
			# Apply friction to side-to-side movement
			var current_velocity = body.linear_velocity
			var belt_direction_velocity = current_velocity.project(direction.normalized())
			var perpendicular_velocity = current_velocity - belt_direction_velocity
			# Stronger damping for perpendicular movement
			if perpendicular_velocity.length() > 0.1:
				body.apply_central_force(-perpendicular_velocity * 5.0)
			# Optional: If objects are getting stuck, apply a small torque to help them rotate
			if body.linear_velocity.length() < 0.5 && body.is_sleeping():
				var random_torque = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
				body.apply_torque(random_torque * 0.5)
		elif body is CharacterBody3D:
			# For character bodies (like players), apply a constant velocity change
			var character_velocity = body.velocity
			character_velocity += direction.normalized() * speed * delta
			body.velocity = character_velocity


func _on_body_entered(body):
	# Add body to our tracking array when it enters the belt area
	if body is RigidBody3D or body is CharacterBody3D:
		if not body in _bodies_on_belt:
			_bodies_on_belt.append(body)
			# Wake up the rigid body if it's sleeping
			if body is RigidBody3D and body.sleeping:
				body.sleeping = false


func _on_body_exited(body):
	# Remove body from our tracking array when it exits
	_bodies_on_belt.erase(body)
	if body is CharacterBody3D:
		# Gradually reduce the velocity
		var tween = get_tree().create_tween()
		tween.tween_property(body, "velocity", Vector3(0.0, -gravity, 0.0), 0.5)
	else:
		# Gradually reduce the velocity
		var tween = get_tree().create_tween()
		tween.tween_property(body, "linear_velocity", Vector3(0.0, -gravity, 0.0), 0.5)
