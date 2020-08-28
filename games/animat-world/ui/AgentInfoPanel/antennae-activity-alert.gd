extends Node2D

const NO_ACTIVITY = Color(0,0,0,0)
const LOW_ACTIVITY = Color(0,0.2,1,0.4)
const MID_ACTIVITY = Color(0,0.2,1,0.7)
const HIGH_ACTIVITY = Color(0,0.2,1,0.95)

onready var smell_effect = $SmellEffect
onready var touch_effect = $TouchEffect

func _ready():
	smell_effect.visible = true
	touch_effect.visible = false	

func set_touch_active():
	print('in touch active')
	touch_effect.visible = true
	
func set_touch_inactive():
	print('in touch inactive')
	touch_effect.visible = false
	
func set_smell_activity_level(level):
	
	if level == 0:
		smell_effect.modulate = NO_ACTIVITY
	elif level == 1:
		smell_effect.modulate = LOW_ACTIVITY
	elif 2 <= level and level <= 3:
		smell_effect.modulate = MID_ACTIVITY
	elif level >= 4:
		smell_effect.modulate = HIGH_ACTIVITY
