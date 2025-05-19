extends Control

@export var start_btn : TextureButton
func _ready():
	# add a button
	#var btn = create_btn({"name": "chane scene", "action": load_main_scene, "filename":"start"})
	#self.add_child(btn)
	#print("ok workd")
	
	start_btn.pressed.connect(load_main_scene)
	
	pass;


func load_level(level: String):
	var lele = load(level)
	var instance = lele.instantiate()
	
	get_tree().root.add_child(instance)
	get_node("/root/Menu").free()
	

func load_basic_scene(): load_level("res://another.tscn")
func load_main_scene(): load_level("res://test_scene.tscn")

func create_btn(item) -> TextureButton:
	var btn = TextureButton.new()
	var texture = load('res://assets/buttons/' + item.filename + '.png')
	var texture_hover = load("res://assets/buttons/"+item.filename+"_hover.png")
	
	btn.texture_normal = texture
	btn.texture_hover = texture_hover
	btn.scale = Vector2(.5,.5)
	btn.connect("pressed", item.action)
	return btn
