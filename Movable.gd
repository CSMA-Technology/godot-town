extends KinematicBody2D

export (String) var goal # Our scene unique name
onready var goal_pos = get_node(goal).global_position
export var speed = 50 # The speed we should move at (pixels per second)
export var arrival_tolerance = 10 # How close to a point do we get before we are there

func _physics_process(delta):
	# When we reach our goal (within tolerance), queue_free
	if global_position.distance_to(goal_pos) <= arrival_tolerance:
		queue_free()
	# If we are not at our goal, keep moving!
	else:
		move_towards_goal(delta * speed)

func move_towards_goal(current_speed): 
	# Get a unit-length vector pointing in the direction we want to go
	var direction = (goal_pos - global_position).normalized()
	# Apply our speed to the direction vector to get our movement vector
	var movement = direction * current_speed
	# Move our KinematicBody2D node
	move_and_collide(movement)
