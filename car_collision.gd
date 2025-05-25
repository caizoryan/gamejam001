extends Area3D
@export var car: Car

func _on_area_entered(area: Area3D) -> void:
	print("area entered LOST BRO")
	car.lose.visible = true
