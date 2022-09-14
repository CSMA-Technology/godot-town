extends KinematicBody2D

export (String) var goal
onready var goal_pos = get_node(goal).global_position
export var current_speed = 50
export var arrival_tolerance = 10

func _ready():
	# Tell the agent where it should navigate to
	$NavigationAgent2D.set_target_location(goal_pos)

func _physics_process(delta):
	# Similar to the car, when the pedestrian gets close enough to the goal, free it
	if global_position.distance_to(goal_pos) <= arrival_tolerance:
		queue_free()
	# Find the next point in the path to navigate to and update the internal path within the agent
	var next_location = $NavigationAgent2D.get_next_location()
	# Calculate the direction and movement just as before
	var direction = (next_location - global_position).normalized()
	var movement = direction * current_speed
	# Sends the movement input to the internal collision avoidance algorithm and sets the agent's velocity
	$NavigationAgent2D.set_velocity(movement * delta)
	
func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	move_and_collide(safe_velocity)
