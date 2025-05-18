extends Node3D

@export var CAR: PackedScene
@export var CAR_SPAWN_RATE: int = 5
@export var CAR_DISTANCE: float = 0.5
@export var SPEED: float = 5

@export var PATH: Path3D
@export var PATH_FOLLOW: PathFollow3D
@export var ROAD_DIRECTION: StateEnums.Direction

var CAR_GROUP = Node3D.new()
var RUN_CARS = false

var spawn_timer = 0
var init_position = Vector3(0,0,0)

func _ready() -> void:
	PATH_FOLLOW.add_child(CAR_GROUP)
	init_position = PATH.curve.get_baked_points()[0]
	print(PATH.curve)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		match event.keycode:
			KEY_E:
				RUN_CARS = !RUN_CARS
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_W:
				var new_car = CAR.instantiate()
				var num_children = CAR_GROUP.get_child_count()
				if num_children == 0:
					new_car.position = init_position
				elif ROAD_DIRECTION == StateEnums.Direction.LEFT_RIGHT:
					new_car.position = init_position - Vector3(0,0,-CAR_DISTANCE * num_children)
				elif ROAD_DIRECTION == StateEnums.Direction.UP_DOWN:
					new_car.position = init_position - Vector3(0,0, -1 * num_children)
				else:
					push_error("Must assign direction to a road object!")
				await get_tree().create_timer(CAR_SPAWN_RATE)
				CAR_GROUP.add_child(new_car)

func _process(delta: float) -> void:
	if RUN_CARS:
		PATH_FOLLOW.progress += SPEED * delta
		if PATH_FOLLOW.progress_ratio == 1.0:
			for node in CAR_GROUP.get_children():
				CAR_GROUP.remove_child(node)
				node.queue_free()
			PATH_FOLLOW.progress_ratio = 0.0
