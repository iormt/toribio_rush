extends RigidBody3D
class_name Bubble

@export var speed : float = 250.0
@export var hitMultiplier = 50;
var bubble_direction : Vector3

enum BubbleStatesEnum {
		WONDER,
		FLEE,
		IDLE,
	}

var is_active : bool = true

@onready var states_dictionary : Dictionary = { BubbleStatesEnum.WONDER : $States/WonderState }

var current_state : BubbleState

func _ready() -> void:
	set_state(states_dictionary[BubbleStatesEnum.WONDER])


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func set_state(new_state : BubbleState) ->void:
	if current_state:
		current_state.exit_state()
	current_state = new_state
	current_state.enter_state(self)


func _calculate_hit_force(value : float, pos : Vector3, direction : Vector3, isThrusting : bool) -> Vector3:
	var returnVector : Vector3
	var dir = self.position - pos
	dir.y = 0
	dir.normalized()
	var dot = dir.dot(direction)
	return (dir) * dot * value * hitMultiplier * (2 if isThrusting else 1)


func get_hit(value : float, pos : Vector3, direction : Vector3, isThrusting : bool) -> void:
	if value > 0.2:
		is_active = false
	var force = _calculate_hit_force(value, pos, direction, isThrusting)
	#print("force: ", force, "value: ", value)
	apply_impulse(force)
