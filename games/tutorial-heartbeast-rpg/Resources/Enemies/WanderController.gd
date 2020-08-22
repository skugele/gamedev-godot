extends Node2D

# the initial position of an object that the WanderController is attached
onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

export(int) var wander_range = 32

func update_target_position():
	var target_vector = Vector2(rand_range(-wander_range, wander_range), 
								rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector			
	
func _on_Timer_timeout():
	update_target_position()

func start_wander_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left
