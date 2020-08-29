extends Node2D

var radius setget set_radius, get_radius
var signature setget set_signature, get_signature

func set_radius(value):
	$Area2D/CollisionShape2D.shape.radius = value
	
func get_radius():
	return $Area2D/CollisionShape2D.shape.radius

func set_signature(value):
	$Area2D.signature = value
	
func get_signature():
	return $Area2D.signature
