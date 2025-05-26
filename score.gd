extends Control

@export var label: Label


func _on_score():
	label.text = str(int(label.text) + 1)
	
func get_score():
	return int(label.text)
	
