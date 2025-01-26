extends Node3D


# Load the custom images for the mouse cursor.
var flag = load("res://Textures/cursor/red_flag.png")
#var beam = load("res://beam.png")


func _ready():	
	# Changes only the arrow shape of the cursor.
	# This is similar to changing it in the project settings.
	Input.set_custom_mouse_cursor(flag)

	# Changes a specific shape of the cursor (here, the I-beam shape).
	#Input.set_custom_mouse_cursor(beam, Input.CURSOR_IBEAM)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
