extends RigidBody3D
class_name Bubble

const TIME_TO_BURST = 0.5

@export var speed : float = 250.0
@export var hit_multiplier : float = 50
var bubble_direction : Vector3
@onready var pop_sound_array = [$pop_sounds/pop_sound_1, 
						$pop_sounds/pop_sound_2, 
						$pop_sounds/pop_sound_3, 
						$pop_sounds/pop_sound_4, 
						$pop_sounds/pop_sound_5,
	]
var pop_to_play : AudioStreamPlayer3D

enum BubbleStatesEnum {
		WONDER,
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
	return (dir) * dot * value * hit_multiplier * (5 if isThrusting else 1)


func get_hit(value : float, pos : Vector3, direction : Vector3, isThrusting : bool) -> void:
	if value > 0.2:
		is_active = false
	var force = _calculate_hit_force(value, pos, direction, isThrusting)
	apply_impulse(force)


func burst_bubble() -> void:
	pop_sound_array.pick_random().play()
	var timer = get_tree().create_timer(TIME_TO_BURST)
	$CollisionShape3D.disabled = true
	visible = false
	timer.connect('timeout', queue_free)
