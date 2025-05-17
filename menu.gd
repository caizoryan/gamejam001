extends GridContainer

@export var marker: CollisionShape3D

# Buttons are instantiated in script
var buttons = [ 
	{ "name": "close", "action": close_menu},
	{ "name": "traffic-light", "action": light_spawn }
]

signal menu_exit

func light_spawn(): spawn("res://trafficlight.tscn")
func spawn(resource):
	var parent = marker.get_parent()
	var scene = parent.get_parent()
	
	var light = load(resource)
	var light_instance = light.instantiate()
	
	print("spawns to position: ", parent, "scene: ", scene)
	scene.add_child(light_instance)
	
	var pos = Vector3(parent.position)
	light_instance.position = pos
	
	close_menu()

func _ready() -> void:
	print("LightMarker: ", marker)
	self.visible = false
	
	for i in buttons:
		var btn = create_btn(i)
		self.add_child(btn)
		
	marker.connect("activated", open_menu)
	
func create_btn(item)->Button:
	var btn = Button.new()
	btn.text = item.name
	btn.connect("pressed", item.action)
	return btn

func open_menu()->void:
	self.visible = true

func close_menu() -> void:
	self.visible = false
	menu_exit.emit()
