extends RigidBody3D
class_name bubble

@export var speed : float = 250.0


var bubble_direction : Vector3


func _ready() -> void:
	bubble_direction = get_random_direction()
	$Timer.start(randf_range(0.5, 1.5))


func _physics_process(delta: float) -> void:
	apply_force(bubble_direction * speed * delta)


func get_random_direction() -> Vector3:
	var random_direction = Vector3(
		randf_range(-1.0, 1.0), 
		0.0, 
		randf_range(-1.0, 1.0)
	).normalized()
	print("random direction: ", random_direction)
	return random_direction


func _on_timer_timeout() -> void:
	bubble_direction = get_random_direction()
	$Timer.start(randf_range(0.5, 1.5))
