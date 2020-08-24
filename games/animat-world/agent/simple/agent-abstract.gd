extends KinematicBody2D

export(int) var MAX_SPEED = 1000
export(float) var MAX_ROTATION = 20
export(float) var APERATURE_ACCELERATION = 30 # in degrees
export(int) var ACCELERATION = 1500
export(int) var FRICTION = 5000

export var MAX_MANDIBLE_APERATURE_IN_DEGREES = 45

onready var left_mandible = $Mandibles/Left
onready var right_mandible = $Mandibles/Right

var hairs = []

# current velocity
var velocity = Vector2.ZERO
var mandible_aperature = 0 # in degrees

func _ready():
	left_mandible.rotation_degrees = mandible_aperature
	right_mandible.rotation_degrees = mandible_aperature

	init_hair()


func init_hair():
	
	# left hairs
	hairs.append($Hairs/Left/Hair1)
	hairs.append($Hairs/Left/Hair2)
	hairs.append($Hairs/Left/Hair3)
	hairs.append($Hairs/Left/Hair4)
	hairs.append($Hairs/Left/Hair5)
	hairs.append($Hairs/Left/Hair6)
	hairs.append($Hairs/Left/Hair7)
	
	# rear hair
	hairs.append($Hairs/Rear)
	
	# right hairs
	hairs.append($Hairs/Right/Hair1)
	hairs.append($Hairs/Right/Hair2)
	hairs.append($Hairs/Right/Hair3)
	hairs.append($Hairs/Right/Hair4)
	hairs.append($Hairs/Right/Hair5)
	hairs.append($Hairs/Right/Hair6)
	hairs.append($Hairs/Right/Hair7)
	
	var id_value = 0
	for hair in hairs:
		hair.id = id_value
		id_value += 1
			
func update_mandible_aperature(change_dir, delta):
		var value = left_mandible.rotation_degrees \
				  + change_dir * APERATURE_ACCELERATION * delta

		if value >= 0 and value <= MAX_MANDIBLE_APERATURE_IN_DEGREES:
			left_mandible.rotation_degrees = value
			right_mandible.rotation_degrees = -value

func _on_hair_active(hair):
	print('name: ', hair.name)
	print('id: ', hair.id)
	hair.print_tree_pretty()
