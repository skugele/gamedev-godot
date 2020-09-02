extends Node2D

onready var health = Globals.DEFAULT_HEALTH setget set_health

# signals
signal dead_or_destroyed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_health(amount):
	health = max(0, amount)
	print('new health: ', health)
	if health <= 0:
		emit_signal("dead_or_destroyed")
	
func _on_damage(amount):
	print('%s took %s damage!' % [self, amount])
	set_health(health - amount)
