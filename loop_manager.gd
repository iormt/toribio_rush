extends Node

var timer = Timer.new()
var time_to_wait : int = 90
var time_available : int
var minutes : int
var seconds : int

var current_points : int = 0
var total_point : int = 240

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.connect("timeout", on_timer_end)
	start_timer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_timer()
	on_all_bubbles_in()
	print(current_points)
	
# ============	POINTS	================
func change_current_points(point_delta:int):
	current_points = current_points + point_delta

func on_all_bubbles_in():
	if current_points == total_point and time_available >= 1:
		show_win_popup()
		print("all bubbles in with time left")
# ============	POINTS	================

# ============	UI	================
func show_win_popup():
	pass
	
func go_to_win_screen():
	var error = get_tree().change_scene_to_file("res://scenes/ui/WinScreen.tscn")
	print(error)
# ============	UI	================

# ============	TIMER	================
func start_timer():
	timer.wait_time = time_to_wait
	timer.start()
	
	
func update_timer():
	time_available = timer.time_left
	minutes = floor( time_available / 60 )
	seconds = int( time_available ) % 60
	return [ minutes , seconds ]
	
	
func on_timer_end():
	if time_available == 0:
		timer.stop()
		go_to_win_screen()
# ============	TIMER	================


func reset_points() -> void:
	current_points = 0
