extends Node

var health setget set_health, get_health

func _ready():
	pass # Replace with function body.

func set_health(value):
	print("Setting health")
	$Damageable.health = value
	
func get_health():
	print("Getting health")
	return $Damageable.health
