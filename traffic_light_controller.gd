extends StaticBody3D
@export var facing: StateEnums.TrafficLight
@export var mesh: MeshInstance3D

var curr_state: StateEnums.TrafficLight

func _ready() -> void:
	self.get_parent().light_changed.connect(_on_light_changed)

func _on_light_changed(state: StateEnums.TrafficLight):
	curr_state = state
	make_active()

func make_active():
	if facing == curr_state: 
		print("facing", facing, "cur", curr_state)	
		change_color(Color.GREEN)
	else: change_color(Color.RED)
 
func change_color(color: Color):
	var child = self.get_child(0)
	var mat = child.get_active_material(0)
	if mat:
		mat.albedo_color = color
	else:
		mat = StandardMaterial3D.new()
		mat.albedo_color = color
		child.material_override = mat
		
