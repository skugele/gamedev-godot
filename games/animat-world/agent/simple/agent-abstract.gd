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

# tactile
onready var active_hairs = [] # 1d int array
onready var active_antennae = [] # 1d int array

# olfactory
onready var active_scents = [] # 1d array of scents from both antennae
onready var combined_scent_sig = null

# current state vars
onready var velocity = Vector2.ZERO
onready var mandible_aperature = 0 # in degrees

########
# vars #
########


###########
# signals #
###########
signal hair_activity_change(activity)
signal antennae_activity_change(activity)
signal smell_activity_change(activity)
signal velocity_change(value)
signal rotation_change(value)
signal mandible_aperture_change(value)

#############
# functions #
#############
func _ready():
	init_sensors()
	init_effectors()	

func _process(delta):
	pass
#	if len(active_scents) > 0:
#		print(active_scents)
#		var combined_scent_sig = get_combined_scent(active_scents)
#		var level = 1 - $Globals.get_magnitude(combined_scent_sig)
#		emit_signal("smell_activity_change", level)
				
func get_combined_scent(active_scents):
	var combined_scent_sig = $Globals.NULL_SMELL
	for scent in active_scents:
		var distance = distance_from_scent(scent)
		var scaling_factor = distance / $Globals.SMELL_DETECTABLE_RADIUS
#		print('scaling_factor: ', scaling_factor)
		var scaled_scent = $Globals.scale(scent.signature, scaling_factor)
#		print('scaled_scent: ', scaled_scent)
		
		combined_scent_sig += scaled_scent
		
	return combined_scent_sig

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
		hairs.append(hair)
		active_hairs.append(0)
		
		# configure signals
		hair.connect("hair_active", self, "_on_hair_active")
		hair.connect("hair_inactive", self, "_on_hair_inactive")
		
		sensor_id += 1
		
	# antennae
	sensor_id = 0
	for antenna in $Antennae.get_children():
		antenna.id = sensor_id		
		antennae.append(antenna)
		
		active_antennae.append(0)
		
		# configure signals
		antenna.connect("antenna_detected_smell", self, "_on_antenna_detected_smell")
		antenna.connect("antenna_lost_smell", self, "_on_antenna_lost_smell")
		
		antenna.connect("antenna_detected_object", self, "_on_antenna_detected_object")
		antenna.connect("antenna_lost_object", self, "_on_antenna_lost_object")
		
		sensor_id += 1

func set_rotation(degrees):
	rotation = degrees
	
func set_mandible_aperature(degrees):
	mandibles[0].rotation_degrees = degrees
	mandibles[1].rotation_degrees = -degrees
	
func distance_from_scent(scent):
	var distance = $Globals.SMELL_DETECTABLE_RADIUS
	
	for antenna in antennae:
		var detector_pos = antenna.smell_detector.global_position
		var scent_pos = scent.global_position
		
		distance = min(distance, detector_pos.distance_to(scent_pos))
	
	return distance

func add_scent(scent):
#	var index = active_scents.find(scent)	
#
#	if index == -1:
#		active_scents.append(scent)
#	else:
#		active_scents[index] = scent
	active_scents.append(scent)
	
func remove_scent(scent):
	var index = active_scents.find(scent)
	
	# found
	if index != -1:
		active_scents.remove(index)
		
func _on_hair_active(hair):
	active_hairs[hair.id] += 1
	emit_signal("hair_activity_change", active_hairs)

func _on_hair_inactive(hair):
	active_hairs[hair.id] -= 1
	emit_signal("hair_activity_change", active_hairs)

func _on_antenna_detected_smell(antenna, scent):
	print('adding: ', scent)
	add_scent(scent)
	print(active_scents)

func _on_antenna_lost_smell(antenna, scent):
	print('removing: ', scent)
	remove_scent(scent)
	print(active_scents)
	
func _on_antenna_detected_object(antenna, body):
	active_antennae[antenna.id] += 1
	emit_signal("antennae_activity_change", active_antennae)
	
func _on_antenna_lost_object(antenna, body):
	active_antennae[antenna.id] -= 1
	emit_signal("antennae_activity_change", active_antennae)

