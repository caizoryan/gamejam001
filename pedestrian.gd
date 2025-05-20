extends Area3D

@export var winmessage : Control
func _on_body_entered(body: Node3D) -> void:
	print("collided, won")
	winmessage.show()
