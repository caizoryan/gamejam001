extends CollisionShape3D
@export var MESH: MeshInstance3D
@export var AREA: Area3D

func _on_ready():
	AREA.connect("input_event", _on_area_input_event)

# Called when the mouse clicks on the Area3D node
func _on_area_input_event(_viewport, event, _shape_idx, _lol, _p):
	print("Clicked on the object!")
	if event is InputEventMouseButton and event.pressed:

		# Change the color of the object (Assuming the object has a material)
		var mat: StandardMaterial3D = MESH.get_active_material(0)
		if mat:
			mat.albedo_color = Color(randf(), randf(), randf())  # Set a random color			area.set_surface_material(0, mat)


#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed():
		#var mat: Material = MESH.get_active_material(0)
		#print("MAT BEFORE IS ", mat.albedo_color)
		#mat.albedo_color = Color(randf(), randf(), randf())
		#print("MAT AFTER IS ", mat.albedo_color)
