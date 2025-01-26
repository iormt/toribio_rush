extends Panel


func _ready() -> void:
	if OS.has_feature("web"):
		$ButtonVerticalContainer/QuitGameButton.visible = false


func _on_start_game_button_button_down() -> void:
	var error = get_tree().change_scene_to_file("res://scenes/maps/test_scene.tscn")
	print(error)


func _on_quit_game_button_button_down() -> void:
	get_tree().quit(0)
