# gdscript: processed-food-bad.gd

extends "res://objects/simple/processed-food-abstract.gd"

func _ready():	
	var scent_attributes = [Globals.FRUIT_SMELL,
							Globals.POISONOUS_FOOD_SMELL,
							Globals.PROCESSED_FOOD_SMELL]
							
	signature = Globals.add_vector_array(scent_attributes)
