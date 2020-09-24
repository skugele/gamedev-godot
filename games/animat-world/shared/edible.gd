extends Node2D

signal edible_consumed
signal edible_exhausted

var amount_left = 1

func _ready():
	pass # Replace with function body.

func reduce():
	
	if amount_left == 0:
		print("Edible exhausted!")
		emit_signal("edible_exhausted", self)
	else:
		print("Edible consumed!")
		
		amount_left -= 1
		emit_signal("edible_consumed", self)
