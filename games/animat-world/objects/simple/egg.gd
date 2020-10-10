# gdscript: egg.gd

extends StaticBody2D

signal destroyed_egg(object)

var signature = null # taste and smell

func _ready():	
	
	# TODO: The signature should be calculated based on some random 
	# perturbations from Gaussian centers. The centers will define 
	# certain characteristics of the objects ("food", "ripe", "agent", etc.)
	signature = Globals.EGG_SMELL
	
	init_scent_areas([25, 100, 250, 500, 1000])
	init_taste_areas()
	
func init_scent_areas(radii):
	for r in radii:
		$Smell.add_scent_area(r, signature)	

func init_taste_areas():
	$Taste.set_signature(signature)

func _on_register_damage(amount):
	print("_on_register_damage invoked")
	emit_signal("destroyed_egg", self)
