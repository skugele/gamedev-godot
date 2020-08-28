extends Node2D

var DEFAULT_RADIUS = 500
var DEFAULT_SMELL = get_default_smell()

const SMELL_DIMENSIONS = 25

export(float) var radius setget set_radius, get_radius
export(Array, float) var signature setget set_signature, get_signature

onready var scent = $Scent
onready var area = $Scent/CollisionShape2D

func _ready():
	radius = DEFAULT_RADIUS
	
func get_default_smell():
	var value = []	
	for d in SMELL_DIMENSIONS:
		value.append(0)
	
func set_radius(value):
	area.shape.radius = value

func get_radius():
	return area.shape.radius
	
func set_signature(value):
	scent.signature = value

func get_signature():
	return scent.signature
