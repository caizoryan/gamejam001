extends GridContainer

@onready var button = $Button3

func _ready() -> void:
	var siggy = $"../../Marker"
	print("Marker: ", siggy)
	self.visible = false
	siggy.get_node("body/collision").connect("activated", _activate)
	
func _activate()->void:
	self.visible = true

func _on_button_3_pressed() -> void:
	self.visible = false
