extends Node
@export var TRAFFIC_LIGHT: StaticBody3D
@export var SPEED: float = 5
@export var CARS: Array[PathFollow3D]

signal intersection_entered

var curr_car = 0

func _ready() -> void:
	TRAFFIC_LIGHT.connect("light_changed", handle_light_change)

func handle_light_change(old_state, new_state):
	if curr_car == 0:
		curr_car = 1
	else:
		curr_car = 0

#func entered_intersection():
	# if car colliding with interection area:
		# emit signal that car is waiting
			# use this signal to determine the direction of entry
			# if there is no light, the first direction just runs forever
			# consumer can count the time it takes to add light, otherwise lose game

func _process(delta):
	CARS[curr_car].progress += SPEED * delta
