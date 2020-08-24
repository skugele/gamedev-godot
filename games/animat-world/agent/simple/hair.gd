extends Node2D

signal hair_active(hair)
signal hair_inactive(hair)

# a unique identifier for this hair
onready var id = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_hair_area_entered(area):
	print('name: ', area.name)
	area.print_tree_pretty()
	emit_signal("hair_active", self)
	
func _on_hair_area_exited(area):
	emit_signal("hair_inactive", self)
	
func _on_hair_body_entered(body):
	print('name: ', body.name)
	body.print_tree_pretty()	
	emit_signal("hair_active", self)
	
func _on_hair_body_exited(area):
	emit_signal("hair_inactive", self)
