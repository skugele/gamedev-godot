extends Node2D

const NO_ACTIVITY = Color(0,0,0,0)
const LOW_ACTIVITY = Color(0,0.2,1,0.4)
const MID_ACTIVITY = Color(0,0.2,1,0.7)
const HIGH_ACTIVITY = Color(0,0.2,1,0.95)

func _ready():
	visible = true

func set_activity_level(level):
	
	if level == 0:
		modulate = NO_ACTIVITY
	elif level == 1:
		modulate = LOW_ACTIVITY
	elif 2 <= level and level <= 3:
		modulate = MID_ACTIVITY
	elif level >= 4:
		modulate = HIGH_ACTIVITY
