extends KinematicBody2D

export(int) var MAX_SPEED = 1000
export(float) var MAX_ROTATION = 20
export(float) var APERATURE_ACCELERATION = 30 # in degrees
export(int) var ACCELERATION = 1500
export(int) var FRICTION = 5000

export var MAX_MANDIBLE_APERATURE_IN_DEGREES = 45

onready var left_mandible = $Mandibles/Left
onready var right_mandible = $Mandibles/Right

# current velocity
var velocity = Vector2.ZERO
var mandible_aperature = 0 # in degrees

func _ready():
	left_mandible.rotation_degrees = mandible_aperature
	right_mandible.rotation_degrees = mandible_aperature

func update_mandible_aperature(change_dir, delta):
		var value = left_mandible.rotation_degrees \
				  + change_dir * APERATURE_ACCELERATION * delta

		if value >= 0 and value <= MAX_MANDIBLE_APERATURE_IN_DEGREES:
			left_mandible.rotation_degrees = value
			right_mandible.rotation_degrees = -value
