extends Area3D

@export var winmessage : Control
@export var progress : TextureProgressBar
@export var camera: Camera3D
@export var top: Node3D


func _process(delta: float) -> void:
	if progress.value > 30: winmessage.visible = true
	if progress.value == 55.: progress.texture_progress = load("res://assets/buttons/1x/prog_tex.png")
	if progress.value == 80.: progress.texture_over = load("res://assets/buttons/1x/overlay.png")
	
	progress.value += 0.03
	print(progress.value)
	var _pos = top.global_position

	if (_pos):
		var pos = camera.unproject_position(_pos)
		pos.y -= 50
		winmessage.set_position(pos)
