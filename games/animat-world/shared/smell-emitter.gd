extends Node2D

onready var signature = null setget set_signature
onready var scent_areas = $ScentAreas

func _ready():
	pass
		
func add_scent_area(radius):
	var scent_area = load("res://shared/scent-area.tscn").instance()
	
#	var collision_shape = scent_area.get_node("CollisionShape2D")
#	var shape = CircleShape2D.new()
#	shape.radius = radius
#
#	collision_shape.set_shape(shape)

	scent_area.init_shape(radius)
#
	scent_areas.add_child(scent_area)
	
	return scent_area
	
func set_signature(value):
	for area in $ScentAreas.get_children():
		area.signature = value
	
func get_default_smell():
	var value = []
	for d in $Globals.SMELL_DIMENSIONS:
		value.append(0)
