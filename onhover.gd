extends Node3D

var hovered: bool = false
var active: bool = false
var highlight_color: Color = Color(1.0,0.0,0,1.0)
var base_color: Color = Color(0.0,0.0,0,1.0)

func _mouse_entered() -> void:
	hovered = true
	set_mesh_color(highlight_color)

func _mouse_exited() -> void:
	hovered = false
	set_mesh_color(base_color)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click"):
		print("pressed, active:", active)
		if (hovered): 
			active = !active
			if (active): 
				highlight_color = Color.YELLOW
				set_mesh_color(highlight_color)
			else: 
				highlight_color = Color.RED
				set_mesh_color(highlight_color)

func set_mesh_color(color: Color)->void:
	$"../mesh".get_active_material(0).albedo_color = color
