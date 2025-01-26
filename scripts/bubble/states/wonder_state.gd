extends BubbleState
class_name WonderState

var bubble_direction : Vector3

var timer : Timer

func enter_state(bubble_ref : Bubble) -> void:
	print("Entered Wonder State")
	super(bubble_ref)
	set_bubble_direction()
	if not timer:
		timer = Timer.new()
		add_child(timer)
		timer.one_shot = true
		timer.autostart = false
		timer.connect("timeout", on_timer_timeout)
	timer.start(randf_range(0.5, 1.5))


func exit_state() -> void:
	print("Existed Wonder State")


func update(_delta : float) -> void:
	pass


func physics_update(delta : float) -> void:
	bubble.apply_force(bubble_direction * bubble.speed * delta)


func get_random_direction() -> Vector3:
	var random_direction = Vector3(
		randf_range(-1.0, 1.0), 
		0.0, 
		randf_range(-1.0, 1.0)
	).normalized()
	return random_direction


func set_bubble_direction() -> void:
	bubble_direction =  get_random_direction()


func on_timer_timeout() -> void:
	set_bubble_direction()
	timer.start(randf_range(0.5, 1.5))
	
