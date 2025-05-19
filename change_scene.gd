extends Control

func _ready():
	# add a button
	var btn = create_btn({"name": "chane scene", "action": load_basic_scene})
	self.add_child(btn)
	
	pass;


func load_level(level: String):
	var lele = load(level)
	var instance = lele.instantiate()
	
	get_tree().root.add_child(instance)
	get_node("/root/Tutorial").free()
	

func load_basic_scene(): load_level("res://another.tscn")

func create_btn(item)->Button:
	var btn = Button.new()
	btn.text = item.name
	btn.connect("pressed", item.action)
	return btn
