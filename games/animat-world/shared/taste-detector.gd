# gdsignal: taste-detector.gd

extends Node2D

signal taste_detected(taste)
signal taste_lost(taste)

func _ready():
	pass # Replace with function body.
	
func enable():
	$Area2D/CollisionShape2D.disabled = false

func disable():
	$Area2D/CollisionShape2D.disabled = true

func _on_area_entered(taste):
#	print('entered: ', taste.name)
	emit_signal("taste_detected", taste)

func _on_area_exited(taste):
#	print('exited: ', taste.name)
	emit_signal("taste_lost", taste)
