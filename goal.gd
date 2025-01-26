extends Node3D


@export var score : int = 10

@export var color  : Color = Color(0.494, 0.337, 1, 0.5)


func _ready() -> void:
	$SM_arc_0.get_active_material(0).albedo_color = color


func _on_goal_body_entered(body: Node3D) -> void:
	if body.is_in_group("bubbles"):
		LoopManager.change_current_points(score)
