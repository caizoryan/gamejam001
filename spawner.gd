extends Node3D

# already linked in object
@export var TIMER: Timer
@export var PATH: Path3D
@export var PATH_FOLLOW: PathFollow3D
@export var COLLISION_AREA: Area3D

# vars that can be controlled
@export var SPAWN_WAIT: float = 0.1
@export var CAR_DISTANCE: float = 0.5
@export var SPEED: float = 5

# references that need to manually be set
@export var CAR: PackedScene
@export var ROAD_DIRECTION: StateEnums.Direction
@export var TRAFFIC_LIGHT: StaticBody3D

# idk some shit I need
var CAR_GROUP = Node3D.new()
var RUN_CARS = false
var CURR_TRAFFIC_DIR = null
var SPAWN_CARS = false
var INIT_POSITION = Vector3(0,0,0)
var CHANGE_QUEUED = null

func _ready() -> void:
	PATH_FOLLOW.add_child(CAR_GROUP)
	INIT_POSITION = PATH.curve.get_baked_points()[0]
	TIMER.timeout.connect(_on_timer_timeout)
	TRAFFIC_LIGHT.connect("light_changed", handle_light_change)
	COLLISION_AREA.area_entered.connect(handle_area_entered)

func handle_area_entered():
	print("hi")

func handle_light_change(new_dir):
	if CURR_TRAFFIC_DIR:
		CHANGE_QUEUED = new_dir
	else:
		CURR_TRAFFIC_DIR = new_dir

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released() and ROAD_DIRECTION == CURR_TRAFFIC_DIR:
		match event.keycode:
			KEY_E:
				RUN_CARS = !RUN_CARS
			KEY_W:
				SPAWN_CARS = !SPAWN_CARS
				if SPAWN_CARS:
					TIMER.start(1.0)
				else:
					TIMER.stop()

func _process(delta: float) -> void:
	if RUN_CARS:
		PATH_FOLLOW.progress += SPEED * delta
		if PATH_FOLLOW.progress_ratio == 1.0:
			for node in CAR_GROUP.get_children():
				CAR_GROUP.remove_child(node)
				node.queue_free()
			PATH_FOLLOW.progress_ratio = 0.0

func _on_timer_timeout():
	var new_car = CAR.instantiate()
	var num_children = CAR_GROUP.get_child_count()
	new_car.position = INIT_POSITION - Vector3(Vector3(0,0,-CAR_DISTANCE * num_children))
	CAR_GROUP.add_child(new_car)  
