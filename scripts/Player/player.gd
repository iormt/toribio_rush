extends CharacterBody3D

enum STATE { WALKING, CHARGING, THRUSTING}

@export var baseSpeed : float = 1
@export var maxSpeed : float = 10
@export var chargeDelay : float = 3
@export var thrustMinDuration : float = .2
@export var thrustMaxDuration : float = 1

@export var curve : Curve

@export var freeRotation : float = 0.04
@export var limitedRotation : float = 0.01

@export var animationPlayer : AnimationPlayer

var currentStateTime : float
var currentState : STATE
var currentSpeed : float

var thrustDuration : float

var target_rotation = Vector3();
var target_velocity = Vector3.ZERO


@onready var camera : Camera3D = $Camera3D

func _ready() -> void:
	change_state(STATE.WALKING)

func change_state(newState : STATE):
	if currentState == newState:
		pass
	currentState = newState
	
	var previousStateTime = currentStateTime
	currentStateTime = 0
	
	match currentState:
		STATE.WALKING:
			animationPlayer.play("walk")
			currentSpeed = baseSpeed
		STATE.CHARGING:
			animationPlayer.play("run")
			pass
		STATE.THRUSTING:
			animationPlayer.play("attack")
			thrustDuration = thrustMinDuration + (thrustMaxDuration - thrustMinDuration) * curve.sample(previousStateTime / chargeDelay)
			pass

func _calculate_rotation_by_state():
	if currentState == STATE.WALKING:
		return freeRotation
	elif currentState == STATE.CHARGING:
		if _is_full_charging():
			return limitedRotation
		else:
			return freeRotation + (limitedRotation - freeRotation) * curve.sample(currentStateTime/chargeDelay)
	elif currentState == STATE.THRUSTING:
		return limitedRotation
	pass

func _update_rotation():
	var mult
	
	if Input.is_action_pressed("left"):
		mult = 1
		pass
	elif Input.is_action_pressed("right"):
		mult = -1
	else:
		return
		
	var rotateAmount = _calculate_rotation_by_state()
	
	self.global_rotate(Vector3.UP, rotateAmount * mult)
	pass

func _is_full_charging() -> bool :
	return currentStateTime >= chargeDelay

func _move_forward() :
	var aim = get_global_transform().basis
	var dir = aim.x
	#dir.y = 0.
	#dir = dir.normalized()
	#apply_central_force(dir * currentSpeed)
	target_velocity.x = dir.x * currentSpeed
	target_velocity.z = dir.z * currentSpeed
	
	velocity = target_velocity
	move_and_slide()
	
	pass

func _update_charge_state_and_speed():
	if currentState == STATE.WALKING:
		if Input.is_action_just_pressed("front"):
			change_state(STATE.CHARGING)
	elif currentState == STATE.CHARGING:
		if _is_full_charging():
			currentSpeed = maxSpeed
		else:
			currentSpeed = baseSpeed + (maxSpeed - baseSpeed) * curve.sample(currentStateTime/chargeDelay)
			
		if not Input.is_action_pressed("front"):
			change_state(STATE.THRUSTING)
	elif currentState == STATE.THRUSTING:
		if currentStateTime >= thrustDuration:
			change_state(STATE.WALKING)
		pass
func _process(_delta):
	currentStateTime += _delta
	_update_charge_state_and_speed()
	_update_rotation()
	
	print("state: ", currentState, " currentTime: ", currentStateTime, " currentSpeed: ", currentSpeed)
	
	#if Input.is_action_just_pressed("camera_shake") :
		#camera.apply_preset_shake(0)

func _physics_process(_delta):
	
	_move_forward()
	
	#var targetPosition = to_local(self.global_position) + Vector3(0, 0, currentSpeed)
	#self.position = to_global(targetPosition)
	
	
