extends Node3D
 
var hovered: bool = false
var active: bool = false

signal activated

@export var menu: GridContainer 

var highlight_color: Color = Color.YELLOW
var base_color: Color = Color.WHITE

func _ready() -> void:
	menu.connect("menu_exit", deactivate)

func deactivate():
	active = false
	set_mesh_color(base_color)
	
func _mouse_entered() -> void:
	hovered = true
	set_mesh_color(highlight_color)

func _mouse_exited() -> void:
	hovered = false
	if (!active): set_mesh_color(base_color)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("key_left"):
		self.get_parent().position.x -= 0.05
		
	if Input.is_action_pressed("key_right"):
		self.get_parent().position.x += .05

	if Input.is_action_pressed("key_up"):
		self.get_parent().position.z-=.05
		
	if Input.is_action_pressed("key_down"):
		self.get_parent().position.z+=.05
	
	if Input.is_action_just_pressed("mouse_click"):
		if (hovered): 
			active = !active
			
		if (active):
			activated.emit() 
			set_mesh_color(highlight_color)

func set_mesh_color(color: Color)->void:
	$"../mesh".get_active_material(0).albedo_color = color
