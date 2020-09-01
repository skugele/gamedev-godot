# gdscript: taste-emitter.gd

extends Node2D

onready var id = null

func _ready():
	id = Globals.generate_unique_id()

func add_taste_area(shape, signature):
	var taste_area = load("res://shared/taste-area.tscn").instance()
	
	taste_area.shape = shape
	taste_area.signature = signature
	taste_area.taste_emitter_id = id

	$TasteAreas.add_child(taste_area)
	
	return taste_area
	
func set_signature(value):
	for area in $TasteAreas.get_children(): 
		area.signature = value
	
