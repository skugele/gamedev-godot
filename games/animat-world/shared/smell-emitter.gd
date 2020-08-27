extends Node2D

var DEFAULT_RADIUS = 500

export(float) var radius setget set_radius, get_radius
export(Array, float) var signature setget set_signature, get_signature

onready var scent = $Scent
onready var area = $Scent/CollisionShape2D

func _ready():
	radius = DEFAULT_RADIUS
	
func set_radius(value):
	area.shape.radius = value

func get_radius():
	return area.shape.radius
	
func set_signature(value):
	scent.signature = value

func get_signature():
	return scent.signature
