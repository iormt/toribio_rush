extends RigidBody3D
class_name Bubble

@export var speed : float = 250.0
@export var hitMultiplier = 50;
var bubble_direction : Vector3
var pop_sound_array = [$pop_sounds/pop_sound_1, $pop_sounds/pop_sound_2, $pop_sounds/pop_sound_3, $pop_sounds/pop_sound_4, $pop_sounds/pop_sound_5]
var pop_to_play : AudioStreamPlayer3D

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
	
	return (dir) * dot * value * hitMultiplier * (5 if isThrusting else 1) + Vector3(0,30,0) #le sumo un vector con fuerza vertical porque siempre daba 0 en Y. Solo para probar


func get_hit(value : float, pos : Vector3, direction : Vector3, isThrusting : bool) -> void:
	if value > 0.2:
		is_active = false
	var force = _calculate_hit_force(value, pos, direction, isThrusting)
	#print("force: ", force, "value: ", value)
	
	#hice lo posible para elegir un sonido random y darle play
	#pop_to_play = pop_sound_array.pick_random() 
	#pop_to_play.play()
	$pop_sounds/pop_sound_4.play()
	apply_impulse(force)
