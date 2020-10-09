# gdscript: globals.gd

extends Node

#############
# constants #
#############
const DEBUG = false

# UI constants
const TIME_FORMAT_STRING = '%02dD %02dH %02dM %02dS %03dms'

const CAMERA_SMOOTHING_ENABLED = true
const CAMERA_SMOOTHING_SPEED = 2

# layer bitmask values
const FIXED_OBJECTS_LAYER = 1
const MANIPULATABLE_OBJECTS_LAYER = 2
const AGENTS_LAYER = 4
const SMELL_EMITTER_LAYER = 8
const SMELL_DETECTOR_LAYER = 16
const TASTE_EMITTER_LAYER = 32
const TASTE_DETECTOR_LAYER = 64
const DAMAGE_ZONE_LAYER = 128
const DAMAGE_DETECTOR_LAYER = 256

###############################
# Environment Characteristics #
###############################
const STATIC = false
const RANDOMIZED = true

const N_RANDOM_TREES = 15
const N_RANDOM_ROCKS = 175

const WORLD_HORIZ_EXTENT = [-20000, 20000]
const WORLD_VERT_EXTENT = [-20000, 20000]

const SMELL_DIMENSIONS = 15
const SMELL_DETECTABLE_RADIUS = 1000

# base smells and tastes
# TODO: What rationale can we use for this encoding scheme? We want to support
# the ability to apply distance metrics to various smells and tastes, so that
# smells and tastes that resemble one another are closer in some metric
# space.
var NULL_SMELL = zero_vector(SMELL_DIMENSIONS)
var UNPROCESSED_FOOD_SMELL = get_sensory_vector([1,5,7])
var UNRIPE_FOOD_SMELL = get_sensory_vector([3,4])
var RIPE_FOOD_SMELL = get_sensory_vector([3,6])
var ROTTEN_FOOD_SMELL = get_sensory_vector([3,6,8,10])
var PROCESSED_FOOD_SMELL = get_sensory_vector([2,9,11])
var AGENT_SMELL = get_sensory_vector([0,12,13,14])
var CHILD_SMELL = get_sensory_vector([6,12,13,14])

# TODO: Need to clean this up. Not sure where they are used, but agent
# related health constants have been moved elsewhere
var FOOD_HEALTH = 1
var EGG_HEALTH = 1
var DEFAULT_HEALTH = 1

###################
# timer constants #
###################
const FRUIT_DROP_RATE_RANGE = [30, 120]

###################
# agent constants #
###################
const AGENT_INITIAL_HEALTH = 100
const AGENT_INITIAL_ENERGY = 50
const AGENT_INITIAL_SATIETY = 50

const AGENT_MAX_HEALTH = 100
const AGENT_MAX_ENERGY = 100
const AGENT_MAX_SATIETY = 100

enum AGENT_SEX {
	A,
	B
}

const COLOR_SEX_A = Color(0.3, 0.0, 0.8, 1.0)
const COLOR_SEX_B = Color(0.4, 0.0, 0.6, 1.0)

############################
# agent movement constants #
############################
const AGENT_MAX_SPEED_FORWARD = 300
const AGENT_MAX_SPEED_BACKWARD = 150

const AGENT_SPRINTING_MAX_SPEED_BOOST = 400

const AGENT_WALKING_ACCELERATION = 500
const AGENT_APERATURE_ACCELERATION = 800

const AGENT_MANDIBLE_CLOSING_ACCELERATION = 800
const AGENT_MANDIBLE_OPENING_ACCELERATION = 100

const AGENT_WALKING_FRICTION = 5000

const AGENT_MAX_ROTATION_RATE = 0.5
const AGENT_MAX_MANDIBLE_APERATURE_IN_DEGREES = 45

# animation constants
const WALKING_PLAYBACK_MULTIPLIER = 3.0
const TURNING_PLAYBACK_MULTIPLIER = 3.0

##########################
# agent action constants #
##########################
enum AGENT_ACTIONS {
	WALKING,
	SPRINTING,
	TURNING,
	OPENING_MANDIBLES,
	CLOSING_MANDIBLES,
	EXTENDING_TONGUE,
	CRUSHING_FOOD,
	ATTACKING,
	EATING,
	MATING
}

const ENERGY_COST_PER_FRAME = {
	AGENT_ACTIONS.SPRINTING: 100,
	AGENT_ACTIONS.WALKING: 25,
	AGENT_ACTIONS.TURNING: 5,
	AGENT_ACTIONS.OPENING_MANDIBLES: 1,
	AGENT_ACTIONS.CLOSING_MANDIBLES: 10,
	AGENT_ACTIONS.EXTENDING_TONGUE: 1,
	AGENT_ACTIONS.EATING: 10
}

const ENERGY_COST_PER_ACTION = {
	AGENT_ACTIONS.CRUSHING_FOOD: 5,
	AGENT_ACTIONS.ATTACKING: 10,
	AGENT_ACTIONS.MATING: 30
}

# Time-based agent stats changes
const SATIETY_DECREASE_PER_FRAME = 0.1
const ENERGY_INCREASE_PER_FRAME = 0.75
const POISON_DECREASE_PER_FRAME = 0.01
const HEALTH_INCREASE_PER_FRAME = 0.1
const ENERGY_DECREASE_WHILE_HEALING_PER_FRAME = 0.25

const POISON_DAMAGE_PER_FRAME = 1.0
const STARVING_DAMAGE_PER_FRAME = 1.0

# Unit-based agent stats changes
const SATIETY_PER_UNIT_FOOD = 25.0
const ENERGY_PER_UNIT_FOOD = 2.0

const AGENT_ATTACK_DAMAGE = 15.0

##################
# Food Constants #
##################
enum FOOD_TYPES {
	GOOD,
	BAD	
}

const FRUIT_DROP_DISTANCE_FROM_TREE = 300 # in pixels

##############################################
# modifiable global state (USE WITH CAUTION) #
##############################################
var global_id = 1000000000 # should never be acessed directly (use generate_unique_id)

# thread locks (mutexes)
var global_id_mutex = Mutex.new() # used in generate_unique_id function

##########################
# synchronized functions #
##########################
func generate_unique_id():
	var id = null
	
	# synchronized block
	global_id_mutex.lock()
	global_id += 1
	id = global_id
	global_id_mutex.unlock()

	return id

##################################################################
# shared functions (THESE FUNCTIONS SHOULD HAVE NO SIDE-EFFECTS) #
##################################################################
func get_sex_as_string(sex):
	return AGENT_SEX.keys()[sex]
		
func get_sensory_vector(active_elements):
	var vector = []
	
	# check for active and set to 1 else 0
	var i = 0
	while i < SMELL_DIMENSIONS:
		
		# not active
		if active_elements.find(i) == -1:
			vector.append(0)
			
		# active
		else:
			vector.append(1)
			
		i += 1
				
	# normalize vector
	return normalize(vector)
	
func get_elapsed_time():
	var milliseconds = (OS.get_ticks_msec())
	
	var remainder = 0
	
	var days = milliseconds / 86400000
	remainder = milliseconds % 86400000
	
	var hours = remainder / 3600000
	remainder = remainder % 3600000
	
	var minutes = remainder / 60000
	remainder = remainder % 60000
	
	var seconds = remainder / 1000
	milliseconds = remainder % 1000	
	
	return [days, hours, minutes, seconds, milliseconds]
	
# assume vectors have same length
func add_vectors(v1, v2):
	var result = v1.duplicate()
	
	var i = 0
	while i < len(v1):
		result[i] += v2[i]
		i += 1
		
	return result		
	
func zero_vector(dims):
	var new_vector = []
	for d in dims:
		new_vector.append(0)
		
	return new_vector
	
func get_magnitude(vector):
	var value = 0.0
	
	for element in vector:
		value += pow(element, 2)
		
	return sqrt(value)
	
func normalize(vector):
	return	scale(vector, 1.0 / get_magnitude(vector))
	
# returns a new array that is the union of two arrays. it assumes that
# each argument is a set (i.e., only contain distinct items)
func union(set1, set2):
	if set2 == null or len(set2) == 0:
		return set1
	elif set1 == null or len(set1) == 0:
		return set2
		
	var new_set = set1.duplicate()
	for element in set2:
		if new_set.find(element) == -1:
			new_set.append(element)
	
	return new_set

# "scales" an array by some scalar value
func scale(array, scalar):
	if array == null or len(array) == 0:
		return array
		
	var new_array = array.duplicate()
	
	var pos = 0
	while pos < len(new_array):
		new_array[pos] *= scalar
		pos += 1
		
	return new_array	
