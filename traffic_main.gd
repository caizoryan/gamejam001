extends Node3D

signal light_changed
var curr_state = StateEnums.Direction.NONE
@export var mesh: MeshInstance3D

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		match event.keycode:
			KEY_1: change_light(StateEnums.Direction.UP)
			KEY_2: change_light(StateEnums.Direction.RIGHT)
			KEY_3: change_light(StateEnums.Direction.DOWN)
			KEY_4: change_light(StateEnums.Direction.LEFT)
				
func change_light(new_state: StateEnums.Direction):
	curr_state = new_state
	print("LIGHT CHANGED DIRECTION TO ",  new_state)
	light_changed.emit(curr_state)
