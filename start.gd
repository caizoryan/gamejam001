extends Control

@export var start_button : TextureButton
@export var camera : Camera3D
@export var score : Control

var pressed: bool = false

func _ready():
	start_button.pressed.connect(_on_press) 

func lerp(start: float, stop: float , amt: float): amt * (stop - start) + start
	
func _process(delta: float) -> void:
	if pressed: 
		camera.size = lerp(camera.size, 23., 0.02)
		if(camera.size > 22): done( )
	
func done():
	pressed = false
	self.visible = false
	score.visible = true
	score._on_score(420)
	
func _on_press():
	print("pressed")
	pressed = true
