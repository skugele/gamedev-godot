# gdscript: food-abstract.gd

signal dead_or_destroyed(object)

extends StaticBody2D

var signature = null # taste and smell
var variety = null   # food type

func is_good():
	return variety == Globals.FOOD_TYPES.GOOD
	
func is_bad():
	return variety == Globals.FOOD_TYPES.BAD
	
func init_scent_areas(radii):
	for r in radii:
		$Smell.add_scent_area(r, signature)	

func init_taste_areas():
	$Taste.set_signature(signature)

func _on_register_damage(amount):
	print("_on_register_damage invoked")
	emit_signal("dead_or_destroyed", self)
