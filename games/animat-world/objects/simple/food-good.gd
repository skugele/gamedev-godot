extends "res://objects/simple/food-abstract.gd"

func _ready():	
	
	# TODO: Need the signature to be normalized to have a vector 
	# magnitude of 1. This will be reduced in "strength" based on the distance
	# between the smell emitter and the smell detector
	
	# TODO: The signature should be calculated based on some random 
	# perturbations from Gaussian centers. The centers will define 
	# certain characteristics of the objects ("food", "ripe", "agent", etc.)
	smell.signature = [0,0,0,0,1,
					   0,0,0,0,1,
					   0,0,0,0,1,
					   0,0,0,0,1,
					   0,0,0,0,1]