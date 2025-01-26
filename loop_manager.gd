extends Node

var timer = Timer.new()
var current_points : int = 0
var time_to_wait : int = 5
var time_available : int
var minutes : int
var seconds : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	start_timer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_timer()
	print(current_points)
	
# ============	POINTS	================
func change_current_points(point_delta:float):
	current_points = current_points + point_delta

# ============	POINTS	================



# ============	TIMER	================
func start_timer():
	timer.wait_time = time_to_wait
	timer.start()
	
	
func update_timer():
	time_available = timer.time_left
	minutes = floor( time_available / 60 )
	seconds = int( time_available ) % 60
	print(minutes," ",seconds )
	on_timer_end()
	return [ minutes , seconds ]
	
func on_timer_end():
	if time_available == 0:
		timer.stop()
		print("no more time")
# ============	TIMER	================
