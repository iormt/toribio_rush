extends Node3D
class_name BubbleState

var bubble : Bubble

func enter_state(bubble_ref : Bubble) -> void:
	if not bubble:
		bubble = bubble_ref


func exit_state() -> void:
	pass


func update(_delta : float) -> void:
	pass


func physics_update(_delta : float) -> void:
	pass
