# gdscript: scent-area.gd

extends Node2D

var smell_emitter_id = null
var signature = null setget set_signature, get_signature
var shape = null setget set_shape, get_shape

func init_shape(radius):
	var new_shape = CircleShape2D.new()
	new_shape.radius = radius
	
	$CollisionShape2D.set_shape(new_shape)
		
func set_shape(new_shape):
	$CollisionShape2D.shape = new_shape
	
func get_shape():
	return $CollisionShape2D.shape

func set_signature(value):
	signature = value
	
func get_signature():
	return signature
