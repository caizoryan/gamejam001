extends Area3D

@export var winmessage : Control
@export var progress : TextureProgressBar
@export var camera: Camera3D
@export var top: Node3D

var changed_to_red = false
var changed_to_panic = false
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

func _process(delta: float) -> void:
	if progress.value > 30: winmessage.visible = true
	if progress.value > 55. && !changed_to_red:
		progress.texture_progress = load("res://assets/buttons/1x/prog_tex.png")
		changed_to_red = true
		
	if progress.value > 80.:
		progress.texture_over = load("res://assets/buttons/1x/overlay.png")
		changed_to_panic = true
	
	progress.value += 0.05
	print(progress.value)
	var _pos = top.global_position

	if (_pos):
		var pos = camera.unproject_position(_pos)
		pos.y -= 50
		if (progress.value > 83.): pos = oscillate(pos)
		winmessage.set_position(pos)
