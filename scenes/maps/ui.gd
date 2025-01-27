extends Node3D

@onready var loop_manager = $/root/LoopManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_points()
	update_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_points()
	update_timer()
	
func update_points():
	$CanvasLayer/SubViewportContainer2/SubViewport/RichTextLabel.text = str(loop_manager.current_points)

func update_timer():
	var minutes : String
	var seconds : String
	if loop_manager.update_timer()[0] > 9:
		minutes = str(loop_manager.update_timer()[0])
	else:
		minutes = "0" + str(loop_manager.update_timer()[0])
	if loop_manager.update_timer()[1] > 9:
		seconds = str(loop_manager.update_timer()[1])
	else:
		seconds = "0" + str(loop_manager.update_timer()[1])
	$CanvasLayer/SubViewportContainer3/SubViewport/RichTextLabel.text = minutes + ":" + seconds
