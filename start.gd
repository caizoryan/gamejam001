extends Control

@export var start_button : TextureButton
@export var camera : Camera3D

var pressed: bool = false

func _ready():
	start_button.pressed.connect(_on_press) 

func lerp(start: float, stop: float , amt: float) -> float:
	return amt * (stop - start) + start
	
func _process(delta: float) -> void:
	if pressed: 
		camera.size += delta * 4.
		if(camera.size > 18): done( )
	
func done():
	pressed = false
	self.visible = false
	
func _on_press():
	print("pressed")
	pressed = true
