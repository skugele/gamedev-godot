# gdscript: mouth.gd
extends Node2D

signal edible_in_range

onready var detector = $Area2D/CollisionShape2D
onready var animation = $Area2D/AnimatedSprite

func _ready():
	animation.visible = false
	detector.disabled = true
	
func _on_edible_in_range(edible):
	emit_signal("edible_in_range", edible)

func activate():
	detector.disabled = false
	animation.visible = true
	animation.frame = 0
	animation.play()
	
	
func deactivate():
	detector.disabled = true
	animation.visible = false
	animation.stop()
