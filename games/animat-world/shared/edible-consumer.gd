extends Node2D

signal detected_edible
signal lost_edible

onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_edible_detected(edible):
	print("detected_edible")
	emit_signal("detected_edible", edible)

func _on_edible_lost(edible):
	print("lost_edible")
	emit_signal("lost_edible", edible)
