# gdscript: food-bad.gd

extends "res://objects/simple/food-abstract.gd"

func _ready():	
	signature = Globals.UNRIPE_FOOD_SMELL
	
	init_scent_areas([100, 250, 500, 1000])
	init_taste_areas()
