extends Area3D
@export var car: Car
@export var timer: Timer

func _ready() -> void:
	timer.timeout.connect(reload_scene)

func reload_scene():
	get_tree().reload_current_scene()

func _on_area_entered(area: Area3D) -> void:
	print("area entered LOST BRO")
	car.handle_lost()
	timer.start()
	
