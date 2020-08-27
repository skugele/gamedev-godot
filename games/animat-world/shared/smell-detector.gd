extends Node2D

signal smell_detected(sensory_data)
signal smell_lost(sensory_date)

func _ready():
	pass # Replace with function body.

func _on_area_entered(scent):
	emit_signal("smell_detected", scent.signature)

func _on_area_exited(scent):
	emit_signal("smell_lost", scent.signature)
