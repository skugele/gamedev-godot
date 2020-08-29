extends Node2D

var signature = null
var shape = null setget set_shape, get_shape

func init_shape(radius):
	var shape = CircleShape2D.new()
	shape.radius = radius
	
	$CollisionShape2D.set_shape(shape)
		
func set_shape(shape):
	$CollisionShape2D.shape = shape
	
func get_shape():
	return $CollisionShape2D.shape
