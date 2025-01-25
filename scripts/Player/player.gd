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
var thrustStartingSpeed : float
var thrustStartingDirection : Vector3

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
			animationPlayer.speed_scale = 1 #setea velocidad de animación
			animationPlayer.get_animation("walk").loop_mode = (Animation.LOOP_LINEAR) #pone animación en loop
			animationPlayer.play("walk")
			currentSpeed = baseSpeed
		STATE.CHARGING:
			#la velocidad de animación se ajusta en _update_charge_state_and_speed()
			animationPlayer.get_animation("run").loop_mode = (Animation.LOOP_LINEAR) #pone animacion en loop
			animationPlayer.play("run")
			pass
		STATE.THRUSTING:
			thrustStartingSpeed = currentSpeed
			thrustStartingDirection = _get_direction()
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
		return freeRotation
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

func _get_direction() -> Vector3 :
	var aim = get_global_transform().basis
	return aim.x
	
func _move_forward(_delta) :
	
	var dir = _get_direction()
	
	#if currentState == STATE.THRUSTING:
		#dir = lerp(thrustStartingDirection, dir, thrustDuration / currentStateTime)
		#pass
	#dir.y = 0.
	#dir = dir.normalized()
	#apply_central_force(dir * currentSpeed)
	target_velocity.x = dir.x * currentSpeed
	target_velocity.z = dir.z * currentSpeed
	
	velocity = target_velocity
	var kinematicCollision3D : KinematicCollision3D = move_and_collide(target_velocity * _delta)
	
	#if (kinematicCollision3D.)
	
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
			animationPlayer.speed_scale = currentSpeed #acelera animación
			
		if not Input.is_action_pressed("front"):
			change_state(STATE.THRUSTING)
	elif currentState == STATE.THRUSTING:
		if currentStateTime >= thrustDuration:
			change_state(STATE.WALKING)
		else:
			currentSpeed = thrustStartingSpeed + (baseSpeed - thrustStartingSpeed) * (currentStateTime/chargeDelay)
		pass
func _process(_delta):
	currentStateTime += _delta
	_update_charge_state_and_speed()
	_update_rotation()
	
	#print("state: ", currentState, " currentTime: ", currentStateTime, " currentSpeed: ", currentSpeed)
	
	#if Input.is_action_just_pressed("camera_shake") :
		#camera.apply_preset_shake(0)

func _physics_process(_delta):
	
	_move_forward(_delta)
	
	#var targetPosition = to_local(self.global_position) + Vector3(0, 0, currentSpeed)
	#self.position = to_global(targetPosition)
	
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("bubbles") and currentState == STATE.THRUSTING:
		
		print(self.rotation)
