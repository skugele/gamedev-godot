extends "res://objects/simple/food-abstract.gd"

onready var smell = $Smell

func _ready():	
	smell.signature = [0,0,0,0,1,
					   0,0,0,0,1,
					   0,0,0,0,1,
					   0,0,0,0,1,
					   0,0,0,0,1]
		
	
