extends Area3D

@export var speed = 5.0 # Speed of the conveyor belt
@export var direction = Vector3(0, 0, 1) # Direction of movement (default: +X axis)
@export var belt_material: StandardMaterial3D # Reference to the belt material for texture animation

var _bodies_on_belt = [] # Array to track objects on the belt

func _ready():
	var belt: MeshInstance3D = $"../Armature/Skeleton3D/BeltConveyor__MI_BeltConveyor_01"
	belt_material = belt.mesh.surface_get_material(0)

func _physics_process(delta):
	# Apply force to all bodies on the belt
	for body in _bodies_on_belt:
		if body is RigidBody3D:
			# For rigid bodies, apply a constant force
			body.apply_central_force(direction.normalized() * speed * .50)
			
			# Optional: Apply some friction to prevent bouncing/sliding
			var current_velocity = body.linear_velocity
			var belt_direction_velocity = current_velocity.project(direction.normalized())
			var perpendicular_velocity = current_velocity - belt_direction_velocity
			
			# Dampen perpendicular movement
			if perpendicular_velocity.length() > 0.1:
				body.apply_central_force(-perpendicular_velocity * 2.0)
		
		elif body is CharacterBody3D:
			# For character bodies (like players), apply a constant velocity change
			var character_velocity = body.velocity
			character_velocity += direction.normalized() * speed * delta
			body.velocity = character_velocity
	
	# Animate the material texture (optional)
	if belt_material:
		belt_material.uv1_offset.y -= speed * .50 * delta * 0.1


func _on_body_entered(body):
	# Add body to our tracking array when it enters the belt area
	if body is RigidBody3D or body is CharacterBody3D:
		if not body in _bodies_on_belt:
			_bodies_on_belt.append(body)

func _on_body_exited(body):
	# Remove body from our tracking array when it exits
	_bodies_on_belt.erase(body)
	if body is CharacterBody3D:
		# Grandualy reduce the velocity
		var tween = get_tree().create_tween()
		tween.tween_property(body, "velocity", Vector3(0.0, -gravity, 0.0), 0.5)
	else:
		# Grandualy reduce the velocity
		var tween = get_tree().create_tween()
		tween.tween_property(body, "linear_velocity", Vector3(0.0, -gravity, 0.0), 0.5)
