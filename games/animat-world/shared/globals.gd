extends Node

#############
# constants #
#############
const SMELL_DIMENSIONS = 5
const SMELL_DETECTABLE_RADIUS = 1500

# should be a constant value, but gdscript does not support function calls to 
# initialize constant values
var NULL_SMELL = zero_vector(SMELL_DIMENSIONS)

##############################################
# modifiable global state (USE WITH CAUTION) #
##############################################

##################################################################
# shared functions (THESE FUNCTIONS SHOULD HAVE NO SIDE-EFFECTS) #
##################################################################
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
		
	
