# gdscript: taste-area.gd

extends Area2D

var taste_emitter_id = null
var signature = null setget set_signature, get_signature
var shape = null setget set_shape, get_shape

func set_shape(new_shape):
	$CollisionShape2D.shape = new_shape
	
func get_shape():
	return $CollisionShape2D.shape

func set_signature(value):
	signature = value
	
func get_signature():
	return signature
	
func enable():
	monitorable = true
	$CollisionShape2D.disabled = false

func disable():
#	print('disabling taste area')
	monitorable = false
	$CollisionShape2D.disabled = true
