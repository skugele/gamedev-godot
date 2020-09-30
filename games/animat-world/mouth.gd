# gdscript: mouth.gd
extends Node2D

signal edible_consumed(edible)

onready var detector = $Area2D/CollisionShape2D
onready var animation = $Area2D/AnimatedSprite

var current_edible = null

func _ready():
	animation.visible = false
	detector.disabled = true

func _on_edible_in_range(edible):
	current_edible = edible
	
func _on_edible_left_range(_edible):
	current_edible = null

func activate():
	detector.disabled = false
	animation.visible = true
	animation.frame = 0
	animation.play()
	
	
func deactivate():
	current_edible = null
	
	detector.disabled = true
	animation.visible = false
	animation.stop()

# this signal correspondings to when the agent's "tongue" finishes lapping
# up some of a liquidified edible object
func _on_animation_finished():
	if current_edible != null:
		emit_signal("edible_consumed", current_edible)
