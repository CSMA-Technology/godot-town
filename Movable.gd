extends KinematicBody2D

export (String) var goal # Our scene unique name
onready var goal_pos = get_node(goal).global_position
export var current_speed = 50 # The speed we should move at (pixels per second)
export var arrival_tolerance = 10 # How close to a point do we get before we are there
export (int, LAYERS_2D_NAVIGATION) var nav_layer = 1
var path = null
var path_idx = 0

func _physics_process(delta):
	# When we reach our goal (within tolerance), queue_free
	if global_position.distance_to(goal_pos) <= arrival_tolerance:
		queue_free()
	# If we are not at our goal, keep moving!
	else:
		move_towards_goal(delta * current_speed)

func move_towards_goal(speed):
	# If the path is null or empty, create it and return. 
	if not path:
		# map_get_path returns an array of points, ending at the goal if it is reachable
		path = Navigation2DServer.map_get_path(get_world_2d().navigation_map, global_position, goal_pos, false, nav_layer)
		# This will point to our next target along the path
		path_idx = 0
		return
	# We are using the same tolerance as before to determine if we have arrived at an intermediate point along the path
	while global_position.distance_to(path[path_idx]) <= arrival_tolerance:
		path_idx += 1
	# Same logic as before, but this time going to the next point in the path instead of the goal
	var direction = (path[path_idx] - global_position).normalized()
	var movement = direction * speed
	move_and_collide(movement)
