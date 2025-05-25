extends CharacterBody3D
class_name Car
enum CAR_STATE {TO_MID, TO_END}

@export var max_speed: float = 5.0
@export var patience: float = 1.0
@export var follow_distance: float = 3.5
@export var horn: AudioStreamPlayer3D

@export var progress : TextureProgressBar
@onready var camera = get_viewport().get_camera_3d()
@export var top: Node3D

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

func play_horn():
	if (!horn.playing): horn.play()
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.is_released():
		#match event.keycode:
			#KEY_E:
				#play_horn()
var oscillator_x = 0
var dir = 1
var max = 3

func oscillate(pos: Vector2) -> Vector2:
	oscillator_x += dir*.8
	
	if (dir == 1):
		if (oscillator_x > max): dir = -1
	else: if (oscillator_x < (max*-1)): dir = 1
	pos.x += oscillator_x
	return pos

var changed_to_red = false
var changed_to_panic = false


func _process(delta: float) -> void:
	if progress.value > 30: progress.visible = true
	if progress.value > 55. && !changed_to_red:
		progress.texture_progress = load("res://assets/buttons/1x/prog_tex.png")
		changed_to_red = true
		#
	if progress.value > 80.:
		progress.texture_over = load("res://assets/buttons/1x/overlay.png")
		changed_to_panic = true
		play_horn()
		
	#
	progress.value += 0.05
	var _pos = top.global_position
	
	if (_pos):
		var pos = camera.unproject_position(_pos)
		pos.y -= 50
		if (progress.value > 83.): pos = oscillate(pos)
		progress.set_position(pos)
