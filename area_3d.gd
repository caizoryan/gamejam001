extends Area3D

func _on_body_entered(body: Node3D) -> void:
	print("body came: ", body)
	spawn("res://marker.tscn", body.global_position)

func spawn(resource: String, postoset: Vector3):
	print("to spawn", resource, "pos: ", postoset)
	var scene = self.get_parent()
	
	var light = load(resource)
	var light_instance = light.instantiate()
	
	scene.add_child(light_instance)
	
	light_instance.position = postoset
	
