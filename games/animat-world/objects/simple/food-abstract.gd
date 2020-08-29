extends StaticBody2D

onready var smell = $Smell
onready var signature = null setget set_signature, get_signature

func _ready():
	pass

func init_scent_areas(radii):
	for r in radii:
		smell.add_scent_area(r)		
		
func set_signature(value):
	smell.signature = value
	
func get_signature():
	return smell.signature	
