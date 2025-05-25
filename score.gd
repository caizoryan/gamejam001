extends Control

@export var label: Label

func _on_score(score):
	label.text = str(score)

func _ready() -> void:
	_on_score(69)
