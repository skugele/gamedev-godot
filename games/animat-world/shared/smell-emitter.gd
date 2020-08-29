extends Node2D

onready var id = null
onready var signature = null setget set_signature
onready var scent_areas = $ScentAreas

func _ready():
	id = Globals.generate_unique_id()
		
func add_scent_area(radius):
	var scent_area = load("res://shared/scent-area.tscn").instance()
	
	scent_area.init_shape(radius)
	scent_area.smell_emitter_id = id
#
	scent_areas.add_child(scent_area)
	
	return scent_area
	
func set_signature(value):
	for area in $ScentAreas.get_children():
		area.signature = value
	
func get_default_smell():
	var value = []
	for d in Globals.SMELL_DIMENSIONS:
		value.append(0)
