extends Control

export(int) var hearts = 4 setget set_hearts
export(int) var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

const HEART_WIDTH = 15/2.0

var stats = PlayerStats

func get_hearts():
	return hearts
	
func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	
	if heartUIFull != null:
		if hearts == 0:
			heartUIFull.visible = false
		else:
			heartUIEmpty.visible = true
			heartUIFull.rect_size.x = hearts * HEART_WIDTH
		

func get_max_hearts():
	return max_hearts
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * HEART_WIDTH

func _ready():
	set_max_hearts(stats.max_health)
	set_hearts(stats.health)
	
	stats.connect("health_changed", self, "set_hearts")	
	stats.connect("max_health_changed", self, "set_max_hearts")
