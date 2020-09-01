# gdscript: antennae-activity-alert.gd

extends Node2D

# Touch Effect Color
const TOUCH_COLOR = Color(1,1,0,0.5)

# Smell Effect Colors
const SMELL_ACTIVITY_COLOR = Color(0,0.2,1,0)
const TASTE_ACTIVITY_COLOR = Color(0,0.9,1,0)
const ALPHA_MAX = 0.85

onready var smell_effect = $SmellEffect
onready var touch_effect = $TouchEffect
onready var taste_effect = $TasteEffect

func _ready():
	smell_effect.visible = true
	set_smell_activity_level(0)
	
	taste_effect.visible = true	
	set_taste_activity_level(0)
	
	touch_effect.visible = false	
	touch_effect.modulate = TOUCH_COLOR

func set_touch_active():
#	print('in touch active')
	touch_effect.visible = true
	
func set_touch_inactive():
#	print('in touch inactive')
	touch_effect.visible = false
	
func set_smell_activity_level(level):
	var color = SMELL_ACTIVITY_COLOR
	color.a = min(level / 3.0, ALPHA_MAX)
		
#	print(color)
	smell_effect.modulate = color

func set_taste_activity_level(level):
	print('setting taste level: ', level)
	var color = TASTE_ACTIVITY_COLOR
	color.a = min(level, ALPHA_MAX)
		
#	print(color)
	taste_effect.modulate = color
