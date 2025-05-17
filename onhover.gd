extends Node3D

var hovered: bool = false
var clicked: bool = false
var highlight_color: Color = Color(1.0,0.0,0,1.0)

func _mouse_entered() -> void:
	hovered = true
	set_mesh_color(highlight_color)

func _mouse_exited() -> void:
	hovered = false
	set_mesh_color(Color(1.0,1.0,0,1.0))
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("mouse_click"):
		if (hovered): 
			clicked = !clicked
			if (clicked): 
				highlight_color = Color(1.0,0.0,1.0,1.0)
				set_mesh_color(highlight_color)
			else: 
				highlight_color = Color.RED
				set_mesh_color(highlight_color)

func set_mesh_color(color: Color)->void:
	$"../mesh".get_active_material(0).albedo_color = color
