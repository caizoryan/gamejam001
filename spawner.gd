extends Node3D

@export var SpawnTimer: Timer
@export var TrafficLight: Node3D
@export var LeftRoad: Node3D
@export var RightRoad: Node3D
@export var UpRoad: Node3D
@export var DownRoad: Node3D
@export var Win: Control

var RoadDict
var SpawnDict
var EndDict
var MidDict
var CarGroups
var NextSpawn = []

@export var CARS: Array[PackedScene]
@export var CAR_PROBS: Array[float]
# spawner variables
# how many cars spawn at the same time
@export var SPAWN_NUM: int = 1
# max and min time spawns can occur
@export var MIN_SPAWN_TIME: float = 1
@export var MAX_SPAWN_TIME: float = 2
# time before difficulty increases
@export var SECS_BEFORE_DIFFICULTY: float = 10
# array of the probs of a specific car type spawning
var CURR_TRAFFIC_DIR = StateEnums.Direction.LEFT

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
	
	MidDict = {
		StateEnums.Direction.LEFT: LeftRoad.get_child(1),
		StateEnums.Direction.RIGHT: RightRoad.get_child(1),
		StateEnums.Direction.UP: UpRoad.get_child(1),
		StateEnums.Direction.DOWN: DownRoad.get_child(1)
	}
	
	EndDict = {
		StateEnums.Direction.LEFT: LeftRoad.get_child(2),
		StateEnums.Direction.RIGHT: RightRoad.get_child(2),
		StateEnums.Direction.UP: UpRoad.get_child(2),
		StateEnums.Direction.DOWN: DownRoad.get_child(2)
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
		var offset = 0
		for j in range(CARS.size()):
			if CAR_PROBS[j] + offset > rand_num:
				NextSpawn.append([CARS[j], StateEnums.random_direction()])
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
		var mid_point = MidDict[dir]
		var end_point = EndDict[dir]
		var new_car = car.instantiate()
		
		spawn_point.get_parent().add_child(new_car)
		new_car.global_position = spawn_point.global_position
		new_car.look_at(end_point.global_position, Vector3.UP)
		print("end_point: ", end_point.global_position)
		new_car.mid_point = mid_point.global_position
		new_car.end_point = end_point.global_position
		
		if(dir == CURR_TRAFFIC_DIR):
			new_car.curr_state = Car.CAR_STATE.TO_END
		
		if CarGroups[dir].size():
			new_car.front_car = CarGroups[dir][-1]

		CarGroups[dir].append(new_car)
	decide_random_spawn()


func handle_light_change(new_dir):
	for prev_car in CarGroups[CURR_TRAFFIC_DIR]:
		if !prev_car.passed_mid:
			prev_car.curr_state = Car.CAR_STATE.TO_MID
	
	CURR_TRAFFIC_DIR = new_dir
	var front_car = null
	for i in range(CarGroups[CURR_TRAFFIC_DIR].size()):
		var car = CarGroups[CURR_TRAFFIC_DIR][i]
		if i == 0:
			front_car = car
		if i > 0:
			car.front_car = front_car
			front_car = car
		car.curr_state = Car.CAR_STATE.TO_END

#func _process(_delta):
	#var to_free = []
	#for dir in StateEnums.Direction.values():
		#if dir == StateEnums.Direction.NONE:
			#return
		#for i in range(CarGroups[dir].size()):
			#var car = CarGroups[dir][i]
			#var end = EndDict[dir].global_position
			#if car.global_position.distance_to(end) < 0.1:
				#car.queue_free()
				#to_free.append(i)
		#for index in to_free:
			#CarGroups[dir].remove_at(index)
			
	
