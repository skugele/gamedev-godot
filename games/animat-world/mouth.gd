# gdscript: mouth.gd
extends Node2D

signal edible_in_range

onready var detector = $Area2D/CollisionShape2D

func _on_edible_in_range(edible):
	emit_signal("edible_in_range", edible)
	
func activate():
	detector.disabled = false
	
func deactivate():
	detector.disabled = true
