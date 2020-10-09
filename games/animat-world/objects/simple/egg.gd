# gdscript: egg.gd

extends "res://objects/simple/food-abstract.gd"

func _ready():	
	
	# TODO: The signature should be calculated based on some random 
	# perturbations from Gaussian centers. The centers will define 
	# certain characteristics of the objects ("food", "ripe", "agent", etc.)
	signature = Globals.RIPE_FOOD_SMELL
	
	init_scent_areas([25, 100, 250, 500, 1000])
	init_taste_areas()

	variety = Globals.FOOD_TYPES.GOOD
