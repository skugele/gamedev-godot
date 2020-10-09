# gdscript: smell-detector.gd

extends Node2D

signal smell_detected(scent)
signal smell_lost(scent)

func _ready():
	pass # Replace with function body.
	
func enable():
	$Area2D/CollisionShape2D.disabled = false

func disable():
	$Area2D/CollisionShape2D.disabled = true

func _on_area_entered(scent):
#	print('entered: ', scent)
	emit_signal("smell_detected", scent)

func _on_area_exited(scent):
#	print('exited: ', scent)
	emit_signal("smell_lost", scent)
