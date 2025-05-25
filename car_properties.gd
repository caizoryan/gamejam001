extends CharacterBody3D
class_name Car
@export var speed: float = 5.0
@export var patience: float = 1.0
@export var horn: AudioStreamPlayer3D

func play_audio():
	horn.play()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		match event.keycode:
			KEY_E:
				play_audio()
