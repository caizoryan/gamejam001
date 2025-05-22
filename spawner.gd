extends Node3D

# already linked in object
@export var SPAWN_POINT: MeshInstance3D
@export var END_POINT: MeshInstance3D
@export var FACING: StateEnums.Direction
@export var CAR: PackedScene = preload("res://default_car.tscn")
@export var TRAFFIC_LIGHT: PackedScene

# spawner variables
# how many cars spawn at the same time
@export var SPAWN_NUM: int = 1
# which/how many directions can spawn at the same time
@export var SPAWN_DIRECTION: Array[StateEnums.Direction]
# max and min time spawns can occur
@export var MIN_SPAWN_DURATION: float = 2
@export var MAX_SPAWN_DURATION: float = 5
# time before difficulty increases
@export var SECS_BEFORE_DIFFICULTY: float = 10
# array of the various car types that can spawn
@export var CAR_TYPES: Array[Car]
# array of the probs of a specific car type spawning
@export var CAR_PROBS: Array[float]

var cars = []
#
## global vars
#var CAR_GROUP = Node3D.new()
#var RUN_CARS = false
var CURR_TRAFFIC_DIR = null
#var SPAWN_CARS = false
#var INIT_POSITION = Vector3(0,0,0)

func _ready():
	if TRAFFIC_LIGHT:
		TRAFFIC_LIGHT.connect("light_changed", handle_light_change)
		print("CAR", CAR)
	var new_car = CAR.instantiate()
	new_car.global_position = SPAWN_POINT.global_position
	SPAWN_POINT.get_parent().add_child(new_car)
	new_car.look_at(END_POINT.global_position, Vector3.UP)
	cars.append(new_car)
	print("END POS", END_POINT.global_position)

func _process(delta):
	for car in cars:
		if car.global_position.distance_to(END_POINT.global_position) < 1.0:
			car.queue_free()
			cars.erase(car)
		#else:
		var velocity = car.global_position.direction_to(END_POINT.global_position) * car.speed
		car.global_position += velocity * delta

func handle_light_change(new_dir):
	CURR_TRAFFIC_DIR = new_dir
	
	

#func _process(delta):
	
	
	

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.is_released() and ROAD_DIRECTION == CURR_TRAFFIC_DIR:
		#match event.keycode:
			#KEY_E:
				#RUN_CARS = !RUN_CARS
			#KEY_W:
				#SPAWN_CARS = !SPAWN_CARS
				#if SPAWN_CARS:
					#TIMER.start(1.0)
				#else:
					#TIMER.stop()
