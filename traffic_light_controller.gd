extends StaticBody3D

signal light_changed

var curr_state = StateEnums.TrafficLight.NONE

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		match event.keycode:
			KEY_S:
				if curr_state == StateEnums.TrafficLight.UP_DOWN:
					change_light(StateEnums.TrafficLight.LEFT_RIGHT)
				else:
					change_light(StateEnums.TrafficLight.UP_DOWN)

func change_light(new_state):
	var prev_state = curr_state
	curr_state = new_state
	print("LIGHT CHANGED DIRECTION TO ",  new_state)
	light_changed.emit(curr_state)
