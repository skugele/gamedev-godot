extends KinematicBody2D

#################
# exported vars #
#################
export(float) var MAX_SPEED = 500
export(float) var MAX_ROTATION = 1.5
export(float) var MAX_MANDIBLE_APERATURE_IN_DEGREES = 45

export(float) var APERATURE_ACCELERATION = 400
export(int) var ACCELERATION = 500
export(int) var FRICTION = 5000

#############
# constants #
#############


################
# onready vars #
################
onready var id = null

# references to sensors and effectors
onready var hairs = []
onready var antennae = []
onready var mandibles = []

# indicators of sensory activity
onready var active_hairs = []
onready var active_scents = [] # per antenna

# current state vars
onready var velocity = Vector2.ZERO
onready var mandible_aperature = 0 # in degrees

########
# vars #
########


###########
# signals #
###########
signal hair_activity_change(hairs)
signal smell_activity_change(antennae)
signal velocity_change(value)
signal rotation_change(value)
signal mandible_aperture_change(value)

#############
# functions #
#############
func _ready():
	init_sensors()
	init_effectors()	

func init_effectors():
	
	# mandibles
	for mandible in $Mandibles.get_children():
		mandibles.append(mandible)
		
	set_mandible_aperature(mandible_aperature)
		
func init_sensors():
	
	# hairs
	var sensor_id = 0
	for hair in $Hairs.get_children():
		hair.id = sensor_id
		sensor_id += 1
		hairs.append(hair)
		active_hairs.append(false)
		
		# configure hair signals
		hair.connect("hair_active", self, "_on_hair_active")
		hair.connect("hair_inactive", self, "_on_hair_inactive")
		
	# antennae
	sensor_id = 0
	for antenna in $Antennae.get_children():
		antenna.id = sensor_id		
		antennae.append(antenna)
		
		# adds an empty list (one per antenna) that will be updated whenever 
		# scents are detected or lost by the agent's antennae
		active_scents.append([])

		sensor_id += 1
		
		# configure hair signals
		antenna.connect("antenna_detected_smell", self, "_on_antenna_detected_smell")
		antenna.connect("antenna_lost_smell", self, "_on_antenna_lost_smell")

func set_rotation(degrees):
	rotation = degrees
	
func set_mandible_aperature(degrees):
	mandibles[0].rotation_degrees = degrees
	mandibles[1].rotation_degrees = -degrees
	
func distance_from_scent(antenna, scent):
	var detector_pos = antenna.smell_detector.position
	var scent_pos = scent.position
	
	return detector_pos.distance_from(scent_pos)

func add_scent(antenna, scent):
	active_scents[antenna.id].append(scent)
	
func remove_scent(antenna, scent):
	var index = active_scents[antenna.id].find(scent)
	
	# found
	if index != -1:
		active_scents[antenna.id].remove(index)
		
func smell_activity_level():
	var levels = []
	for antenna in antennae:
		levels.append(len(active_scents[antenna.id]))
		
	return levels
		
func _on_hair_active(hair):
	active_hairs[hair.id] = true
	emit_signal("hair_activity_change", active_hairs)

func _on_hair_inactive(hair):
	active_hairs[hair.id] = false
	emit_signal("hair_activity_change", active_hairs)

func _on_antenna_detected_smell(antenna, scent):
	add_scent(antenna, scent)
	emit_signal("smell_activity_change", smell_activity_level())

func _on_antenna_lost_smell(antenna, scent):
	remove_scent(antenna, scent)
	emit_signal("smell_activity_change", smell_activity_level())
