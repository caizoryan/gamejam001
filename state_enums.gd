extends Node
class_name StateEnums

# what direction in traffic light is currently green
enum Direction {LEFT, RIGHT, UP, DOWN, NONE = -1}

static func random_direction():
	randomize()
	return randi() % 4 # don't want to pick none as a direction
