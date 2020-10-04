# gdscript: food-abstract.gd

signal dead_or_destroyed(object)

extends StaticBody2D

var signature = null

# food varieties
enum  {
	GOOD,
	BAD
}

var variety = null

func is_good():
	return variety == GOOD
	
func is_bad():
	return variety == BAD
	
func init_scent_areas(radii):
	for r in radii:
		$Smell.add_scent_area(r, signature)	

func init_taste_areas():
	$Taste.set_signature(signature)

func _on_dead_or_destroyed():
#	print("%s has been destroyed"%[self])
	emit_signal("dead_or_destroyed", self)
