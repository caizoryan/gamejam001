extends Node3D

@export var SpawnTimer: Timer
@export var TrafficLight: Node3D
@export var LeftRoad: Node3D
@export var RightRoad: Node3D
@export var UpRoad: Node3D
@export var DownRoad: Node3D

var RoadDict
var SpawnDict
var EndDict
var CarGroups
var NextSpawn = []

@export var CARS: Array[PackedScene]
@export var CAR_PROBS: Array[float]
# spawner variables
# how many cars spawn at the same time
@export var SPAWN_NUM: int = 1
# which/how many directions can spawn at the same time
@export var SPAWN_DIRECTION: Array[StateEnums.Direction]
# max and min time spawns can occur
@export var MIN_SPAWN_TIME: float = 1
@export var MAX_SPAWN_TIME: float = 2
# time before difficulty increases
@export var SECS_BEFORE_DIFFICULTY: float = 10
# array of the probs of a specific car type spawning
var CURR_TRAFFIC_DIR = StateEnums.Direction.NONE

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
	
	var total_prob = 0
	for probs in CAR_PROBS:
		total_prob += probs
	if total_prob != 1.0:
		push_error("yooo: car probs must add up to exactly 1.0") 
	elif CARS.size() != CAR_PROBS.size():
		push_error("yoooo: the probs and car num are not equal")
	else:
		for i in range(CARS.size()):
			print("PROB OF CAR ", CARS[i], ": ", CAR_PROBS[i])
		decide_random_spawn()

func decide_random_spawn():
	randomize()
	NextSpawn = []
	# decide what spawns
	for i in range(SPAWN_NUM):
		var rand_num = randf()
		print("RANDOM NUMBER WAS ", rand_num)
		var offset = 0
		for j in range(CARS.size()):
			if CAR_PROBS[j] > rand_num + offset:
				NextSpawn.append([CARS[j], StateEnums.random_direction()])
				print("SPAWNING ", j, " IN DIRECTION", NextSpawn[-1][1])
				break
			else:
				offset += CAR_PROBS[j]
	# timeout - after which the spawn happens
	SpawnTimer.start(randf_range(MIN_SPAWN_TIME, MAX_SPAWN_TIME))

func spawn_on_timeout():
	for CarDir in NextSpawn:
		var car = CarDir[0]
		var dir = CarDir[1]
		var spawn_point = SpawnDict[dir]
		var end_point = EndDict[dir]
		var new_car = car.instantiate()
		new_car.global_position = spawn_point.global_position
		spawn_point.get_parent().add_child(new_car)
		new_car.look_at(end_point.global_position, Vector3.UP)
		CarGroups[dir].append(new_car)
	decide_random_spawn()


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
