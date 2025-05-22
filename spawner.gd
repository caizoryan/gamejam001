extends Node3D

@export var TrafficLight: Node3D
@export var LeftRoad: Node3D
@export var RightRoad: Node3D
@export var UpRoad: Node3D
@export var DownRoad: Node3D
var RoadDict
var SpawnDict
var EndDict
var CarGroups

@export var CAR: PackedScene = preload("res://car.tscn")

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
var CURR_TRAFFIC_DIR = StateEnums.Direction.NONE
#var SPAWN_CARS = false
#var INIT_POSITION = Vector3(0,0,0)

func _ready():
	if TrafficLight:
		TrafficLight.connect("light_changed", handle_light_change)

	RoadDict = {
		StateEnums.Direction.LEFT: LeftRoad,
		StateEnums.Direction.RIGHT: RightRoad,
		StateEnums.Direction.UP: UpRoad,
		StateEnums.Direction.DOWN: DownRoad,
	}
	
	SpawnDict = {
		StateEnums.Direction.LEFT: LeftRoad.get_child(0),
		StateEnums.Direction.RIGHT: RightRoad.get_child(0),
		StateEnums.Direction.UP: UpRoad.get_child(0),
		StateEnums.Direction.DOWN: DownRoad.get_child(0)
	}
	
	EndDict = {
		StateEnums.Direction.LEFT: LeftRoad.get_child(1),
		StateEnums.Direction.RIGHT: RightRoad.get_child(1),
		StateEnums.Direction.UP: UpRoad.get_child(1),
		StateEnums.Direction.DOWN: DownRoad.get_child(1)
	}
	
	CarGroups = {
		StateEnums.Direction.LEFT: [],
		StateEnums.Direction.RIGHT: [],
		StateEnums.Direction.UP: [],
		StateEnums.Direction.DOWN: []
	}

func _process(delta):
	if CURR_TRAFFIC_DIR == StateEnums.Direction.NONE:
		return
	var end = EndDict[CURR_TRAFFIC_DIR]
	for car in CarGroups[CURR_TRAFFIC_DIR]:
		if car.global_position.distance_to(end.global_position) < 1.0:
			car.queue_free()
			CarGroups[CURR_TRAFFIC_DIR].erase(car)
		#else:
		var velocity = car.global_position.direction_to(end.global_position) * car.speed
		car.global_position += velocity * delta

func handle_light_change(new_dir):
	if CURR_TRAFFIC_DIR == StateEnums.Direction.NONE:
		CURR_TRAFFIC_DIR = new_dir
		RoadDict[CURR_TRAFFIC_DIR].run_cars = true
	else:	
		RoadDict[CURR_TRAFFIC_DIR].run_cars = false
		CURR_TRAFFIC_DIR = new_dir
		RoadDict[CURR_TRAFFIC_DIR].run_cars = true

	var spawn = SpawnDict[CURR_TRAFFIC_DIR]
	var end = EndDict[CURR_TRAFFIC_DIR]
	var new_car = CAR.instantiate()
	new_car.global_position = spawn.global_position
	spawn.get_parent().add_child(new_car)
	new_car.look_at(end.global_position, Vector3.UP)
	CarGroups[CURR_TRAFFIC_DIR].append(new_car)
	

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
