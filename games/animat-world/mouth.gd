# gdscript: mouth.gd
extends Node2D

signal edible_in_range
signal edible_left_range

func _on_edible_in_range(edible):
	emit_signal("edible_in_range", edible)
	
func _on_edible_left_range(edible):
	emit_signal("edible_left_range", edible)
