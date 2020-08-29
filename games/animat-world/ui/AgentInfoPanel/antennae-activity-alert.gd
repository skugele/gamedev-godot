extends Node2D

# Touch Effect Color
const TOUCH_COLOR = Color(1,1,0,0.5)

# Smell Effect Colors
const SMELL_ACTIVITY_COLOR = Color(0,0.2,1,0)

onready var smell_effect = $SmellEffect
onready var touch_effect = $TouchEffect

func _ready():
	smell_effect.visible = true
	
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
	color.a = level
		
#	print(color)
	smell_effect.modulate = color

