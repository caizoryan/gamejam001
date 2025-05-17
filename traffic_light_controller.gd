extends StaticBody3D

signal light_changed

var curr_state = StateEnums.TrafficLight.NONE

func change_light(new_state):
	var prev_state = curr_state
	curr_state = new_state
	light_changed.emit(prev_state, curr_state)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		print("traffic controller input: ", event)
		if curr_state == StateEnums.TrafficLight.NONE:
			change_light(StateEnums.TrafficLight.LEFT_RIGHT)
		else:
			change_light(StateEnums.TrafficLight.NONE)
