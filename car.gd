extends CharacterBody3D
class_name Car
enum CAR_STATE {TO_MID, TO_END}

@export var max_speed: float = 5.0
@export var patience: float = 1.0
@export var follow_distance:float = 3.5
var curr_speed = max_speed
var curr_state = CAR_STATE.TO_MID
var mid_point = null
var end_point = null
var front_car = null
var passed_mid = false

func _physics_process(delta: float):
	var goal = mid_point
	if curr_state == CAR_STATE.TO_END:
		goal =  end_point
		curr_speed = max_speed
	
	elif front_car and !front_car.passed_mid:
		goal = front_car.global_position
	
	if goal != end_point and global_position.distance_to(goal) < follow_distance:
		curr_speed = 0
	
	if global_position.distance_to(mid_point) < 0.1:
		passed_mid = true


	var direction = -transform.basis.z.normalized() # Local forward vector
	velocity = direction * curr_speed
	move_and_slide()


@export var horn: AudioStreamPlayer3D

func play_horn():
	horn.play()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		match event.keycode:
			KEY_E:
				play_horn()
