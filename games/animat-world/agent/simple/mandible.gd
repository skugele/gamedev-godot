# gdscript: mandible.gd

extends Node2D

func _ready():
	pass # Replace with function body.

func enable():
	$Area2D/CollisionPolygon2D.disabled = false
	
func disable():
	$Area2D/CollisionPolygon2D.disabled = true
