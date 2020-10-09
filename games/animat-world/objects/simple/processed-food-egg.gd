# gdscript: processed-food-good.gd

extends "res://objects/simple/processed-food-abstract.gd"

func _ready():	
	pass

func init_from_egg(egg):
	global_position = egg.global_position

	signature = egg.signature
	variety = egg.variety
	
	# TODO: This is ugly. Need to refactor to have the radii as
	# top-level attributes of a scent area, and the scent areas
	# be accessible as a collection variable
	for scent_area in egg.get_node("Smell/ScentAreas").get_children():
		$Smell.add_scent_area(scent_area.radius, signature)			
	
	$Taste.set_signature(signature)
