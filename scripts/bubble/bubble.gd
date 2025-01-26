extends RigidBody3D
class_name Bubble

@export var speed : float = 250.0

@export var hitMultiplier = 50;

var bubble_direction : Vector3

var is_Active = true

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
	#print("random direction: ", random_direction)
	return random_direction


func _on_timer_timeout() -> void:
	if not is_Active:
		return
	bubble_direction = get_random_direction()
	$Timer.start(randf_range(0.5, 1.5))

func _calculate_hit_force(value : float, position : Vector3, direction : Vector3, isThrusting : bool) -> Vector3:
	var returnVector : Vector3
	var dir = self.position - position
	dir.normalized()
	var dot = dir.dot(direction)
	return (dir + Vector3.UP) * dot * value * hitMultiplier * (2 if isThrusting else 1)

func get_hit(value : float, position : Vector3, direction : Vector3, isThrusting : bool) -> void:
	if value > 0.2:
		is_Active = false
	var force = _calculate_hit_force(value, position, direction, isThrusting)
	print("force: ", force, "value: ", value)
	apply_impulse(force)
	
	pass
