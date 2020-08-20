extends Node

export(int) var max_health setget set_max_health
export(int) var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	
	emit_signal("max_health_changed", max_health)

func _ready():
	health = max_health
