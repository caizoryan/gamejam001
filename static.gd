extends StaticBody3D

@export var r: float = 0.92

func _process(delta: float) -> void:
	$".".get_active_material(0).albedo_color = Color(1, r, 0, 1)
	
