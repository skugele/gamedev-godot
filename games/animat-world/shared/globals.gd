# gdscript: globals.gd

extends Node

#############
# constants #
#############
const SMELL_DIMENSIONS = 15
const SMELL_DETECTABLE_RADIUS = 1000

const TIME_FORMAT_STRING = '%02dD %02dH %02dM %02dS %03dms'

# constants for agent camera
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

# default health
var DEFAULT_HEALTH = 1
var FOOD_HEALTH = 1
var EGG_HEALTH = 1
var AGENT_HEALTH = 5

###################
# agent constants #
###################
const AGENT_MAX_HEALTH = 10
const AGENT_MAX_ENERGY = 50
const AGENT_MAX_SATIETY = 100

enum AGENT_SEX {
	A,
	B
}

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
