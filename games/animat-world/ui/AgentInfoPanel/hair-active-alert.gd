extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.visible = false

func set_active():
	sprite.visible = true
	
func set_inactive():
	sprite.visible = false
