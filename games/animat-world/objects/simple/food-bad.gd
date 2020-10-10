# gdscript: food-bad.gd

extends "res://objects/simple/food-abstract.gd"

func _ready():	
	signature = Globals.add_vectors(Globals.FRUIT_SMELL, 
									Globals.POISONOUS_FOOD_SMELL)
	
	init_scent_areas([100, 250, 500, 1000])
	init_taste_areas()

	variety = Globals.FOOD_TYPES.BAD
