extends Control



func _ready() -> void:
	$WinPanel/VBoxContainer/WinMessageLabel.text = "Puntaje final " + str(LoopManager.current_points)


func go_to_main_menu() -> void:
	LoopManager.reset_points()
	var error = get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
	print(error)


func rematch() -> void:
	LoopManager.reset_points()
	LoopManager.start_timer()
	var error = get_tree().change_scene_to_file("res://scenes/maps/test_scene.tscn")
	print(error)


func quit() -> void:
	get_tree().quit(0)


func _on_rematch_button_button_down() -> void:
	rematch()


func _on_main_menu_button_button_down() -> void:
	go_to_main_menu()
