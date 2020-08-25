extends Node2D

signal hair_active(hair)
signal hair_inactive(hair)

# a unique identifier for this hair
onready var id = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_hair_body_entered(_body):
	emit_signal("hair_active", self)
	
func _on_hair_body_exited(_body):
	emit_signal("hair_inactive", self)
