# gdscript: agent-stats.gd

extends Node2D

export(int) var age = 0
export(String, "A", "B") var sex
export(int, 0, 10) var health = 5
export(int, 0, 100) var energy = 50

var children_current = 0
var children_total = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
