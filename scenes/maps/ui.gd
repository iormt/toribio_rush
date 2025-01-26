extends Node3D

@onready var loop_manager = $/root/LoopManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_points()
	update_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_points()
	update_timer()
	
func update_points():
	$CanvasLayer/SubViewportContainer2/SubViewport/RichTextLabel.text = str(loop_manager.current_points)

func update_timer():
	$CanvasLayer/SubViewportContainer3/SubViewport/RichTextLabel.text = str(loop_manager.update_timer()[0],":",loop_manager.update_timer()[1])
