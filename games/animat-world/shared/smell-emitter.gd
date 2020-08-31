# gdscript: smell-emitter.gd

extends Node2D

onready var id = null

func _ready():
	id = Globals.generate_unique_id()
		
func add_scent_area(radius, signature):
	var scent_area = load("res://shared/scent-area.tscn").instance()
	
	scent_area.init_shape(radius)
	scent_area.smell_emitter_id = id
	scent_area.signature = signature
#
	$ScentAreas.add_child(scent_area)
	
	return scent_area
	
func set_signature(value):
	for area in $ScentAreas.get_children():
		area.signature = value
