extends Node2D

# preloads the GrassEffect scene from resources in file system	
const EffectScene = preload("res://Resources/Effects/GrassEffect.tscn")

func create_grass_effect():	
	# creates a new object instance of that scene
	var effect = EffectScene.instance()
	
	# gets the root node of the current scene
	var world = get_tree().current_scene
	
	# adds new object for GrassAttackedEffect to world scene node tree
	world.add_child(effect)
	
	# the position of the new node defaults to the origin of the world,
	# so we need to set its position to be the current global position
	# of *this* grass node
	effect.global_position = global_position

# Emitted when any other area overlaps with this one. The other area that
# overlaps is passed as an argument.
func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
