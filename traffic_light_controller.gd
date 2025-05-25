extends StaticBody3D
@export var facing: StateEnums.Direction
@export var mesh: MeshInstance3D
enum LIGHTSTATE {RED, GREEN}
var curr_state: StateEnums.Direction

func _ready() -> void:
	self.get_parent().light_changed.connect(_on_light_changed)

func _on_light_changed(state: StateEnums.Direction):
	curr_state = state
	make_active()

func make_active():
	if facing == curr_state: 
		print("facing", facing, "cur", curr_state)	
		change_color(LIGHTSTATE.GREEN)
	else: change_color(LIGHTSTATE.RED)

func get_red(): self.get_child(0)
func get_green(): self.get_child(1)

func set_red(iss: bool):
	var child = self.get_child(0)
	var mat = child.get_active_material(0)
	var color = Color.RED
	if (!iss): color = Color.BLACK
	else: set_marker(Color.RED)
	if mat:
		mat.albedo_color = color
	else:
		mat = StandardMaterial3D.new()
		mat.albedo_color = color
		child.material_override = mat
		
func set_green(iss: bool):
	var child = self.get_child(1)
	var mat = child.get_active_material(0)
	var color = Color.GREEN
	if (!iss): color = Color.BLACK
	else: set_marker(Color.GREEN)
	if mat:
		mat.albedo_color = color
	else:
		mat = StandardMaterial3D.new()
		mat.albedo_color = color
		child.material_override = mat
		
func set_marker(color: Color):
	var child = self.get_child(2)
	var mat = child.get_active_material(0)

	if mat:
		mat.albedo_color = color
	else:
		mat = StandardMaterial3D.new()
		mat.albedo_color = color
		child.material_override = mat
		
func change_color(state: LIGHTSTATE):
	if (state == LIGHTSTATE.GREEN):
		set_red(false)
		set_green(true)
	if (state == LIGHTSTATE.RED):
		set_red(true)
		set_green(false)
