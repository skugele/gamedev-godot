extends "res://agent/simple/agent-abstract.gd"

func _ready():
	id = Globals.generate_unique_id()
	
	init_sensors()
	init_effectors()	
	init_agent_smell()
