extends KinematicBody2D

export(int) var MAX_SPEED = 500
export(float) var MAX_ROTATION = 1.5
export(float) var APERATURE_ACCELERATION = 400
export(int) var ACCELERATION = 500
export(int) var FRICTION = 5000

export var MAX_MANDIBLE_APERATURE_IN_DEGREES = 45

onready var left_mandible = $AgentBodyParts/Mandibles/Left
onready var right_mandible = $AgentBodyParts/Mandibles/Right

signal hair_activity_change(hairs)
signal velocity_change(value)
signal rotation_change(value)
signal mandible_aperture_change(value)

onready var id = null
onready var hairs = []
onready var active_hairs = []

# current velocity
onready var velocity = Vector2.ZERO
onready var mandible_aperature = 0 # in degrees

func _ready():
	left_mandible.rotation_degrees = mandible_aperature
	right_mandible.rotation_degrees = mandible_aperature

	init_hair()	

func init_hair():

	# left hairs
	hairs.append($AgentBodyParts/Hairs/Left/Hair1)
	hairs.append($AgentBodyParts/Hairs/Left/Hair2)
	hairs.append($AgentBodyParts/Hairs/Left/Hair3)
	hairs.append($AgentBodyParts/Hairs/Left/Hair4)
	hairs.append($AgentBodyParts/Hairs/Left/Hair5)
	hairs.append($AgentBodyParts/Hairs/Left/Hair6)
	hairs.append($AgentBodyParts/Hairs/Left/Hair7)
	
	# rear hair
	hairs.append($AgentBodyParts/Hairs/Rear)
	
	# right hairs
	hairs.append($AgentBodyParts/Hairs/Right/Hair1)
	hairs.append($AgentBodyParts/Hairs/Right/Hair2)
	hairs.append($AgentBodyParts/Hairs/Right/Hair3)
	hairs.append($AgentBodyParts/Hairs/Right/Hair4)
	hairs.append($AgentBodyParts/Hairs/Right/Hair5)
	hairs.append($AgentBodyParts/Hairs/Right/Hair6)
	hairs.append($AgentBodyParts/Hairs/Right/Hair7)
	
	var id_value = 0
	for hair in hairs:
		hair.id = id_value
		id_value += 1
		
		# configure hair signals
		hair.connect("hair_active", self, "_on_hair_active")
		hair.connect("hair_inactive", self, "_on_hair_inactive")
		
		# set all hairs to be inactive
		active_hairs.append(false)		

func set_rotation(degrees):
	rotation = degrees
	
func set_mandible_aperature(degrees):
	left_mandible.rotation_degrees = degrees
	right_mandible.rotation_degrees = -degrees
				
func _on_hair_active(hair):
	active_hairs[hair.id] = true
	emit_signal("hair_activity_change", active_hairs)

func _on_hair_inactive(hair):
	active_hairs[hair.id] = false
	emit_signal("hair_activity_change", active_hairs)
