# gdscript: abstract-agent.gd

extends KinematicBody2D

#################
# exported vars #
#################
export(float) var MAX_SPEED = max(Globals.AGENT_MAX_SPEED_FORWARD, Globals.AGENT_MAX_SPEED_BACKWARD)
export(float) var MAX_ROTATION = Globals.AGENT_MAX_ROTATION_RATE
export(float) var MAX_MANDIBLE_APERATURE_IN_DEGREES = Globals.AGENT_MAX_MANDIBLE_APERATURE_IN_DEGREES

export(float) var APERATURE_ACCELERATION = Globals.AGENT_APERATURE_ACCELERATION
export(int) var ACCELERATION = Globals.AGENT_WALKING_ACCELERATION
export(int) var FRICTION = Globals.AGENT_WALKING_FRICTION

export(Globals.AGENT_SEX) var sex setget set_sex

#############
# constants #
#############

# animation-related vars
enum LEG_ANIMATION_STATE {
	MOVING,
	IDLE
}

onready var leg_animation_state = LEG_ANIMATION_STATE.IDLE

onready var is_turning = false
onready var is_walking = false

################
# onready vars #
################
onready var id = null
onready var stats = $Stats
onready var torso = $Torso

onready var leg_animator = $Legs/LegAnimationPlayer
onready var hit_effect = $HitEffect

# references to sensors and effectors
onready var hairs = []
onready var antennae = []
onready var mandibles = []
onready var mouth = $Mouth
onready var pheromone_emitter = $PheromoneEmitter

# indicators of sensory activity

# tactile
onready var active_hairs = [] # 1d int array
onready var active_antennae = [] # 1d int array

# olfactory
onready var active_scents = {} # dictionary of scent emitters ids -> active scent areas
onready var ignored_scents = [] # ignore own smells
onready var combined_scent_sig = null

# taste
onready var active_tastes = {} # dictionary of taste emitters ids -> active taste areas
onready var ignored_tastes = [] # ignore own tastes
onready var combined_taste_sig = null

# current state vars
onready var velocity = Vector2.ZERO setget set_velocity

# effector variables
onready var damageables = []
onready var mandible_aperature = 0 # in degrees

########
# vars #
########
var signature = null
var actions = []

###########
# signals #
###########
# TODO: Once we have multiple agents it may be good to always
# send an agent reference object in these signals
signal hair_activity_change(activity)
signal antennae_activity_change(activity)
signal smell_activity_change(activity)
signal taste_activity_change(activity)

signal agent_eating(agent, edible)
signal agent_chemical_signal(agent, chemical_signal)
signal agent_dead(agent)

#############
# functions #
#############
func _ready():
	choose_sex()		
	reset_legs()
	
	# for hit effect animation
	hit_effect.frame = 0

func _process(delta):
	process_metabolic_costs(delta)

	match(leg_animation_state):
		LEG_ANIMATION_STATE.MOVING:
			set_legs_moving()
			
		LEG_ANIMATION_STATE.IDLE:
			set_legs_stopped()
	
	# update leg animation state
	if is_walking or is_turning:
		leg_animation_state = LEG_ANIMATION_STATE.MOVING
	else:
		leg_animation_state = LEG_ANIMATION_STATE.IDLE

func set_legs_moving():
	
	# adjust playback rate based on action
	if is_walking:
		leg_animator.playback_speed = (velocity.length() / Globals.AGENT_MAX_SPEED_FORWARD) * Globals.WALKING_PLAYBACK_MULTIPLIER
	elif is_turning:
		leg_animator.playback_speed = Globals.AGENT_MAX_ROTATION_RATE * Globals.TURNING_PLAYBACK_MULTIPLIER
	else:
		leg_animator.playback_speed = 1.0
		
	leg_animator.play("Moving")
	
func set_legs_stopped():
	# it's necessary to stop the current animation rather than play "Idle"
	# to avoid a jumpy transition in leg position
	leg_animator.stop()

func reset_legs():
	# resets leg position to resting state
	leg_animator.play("Idle")
	
func set_velocity(value):
	velocity = value
	
	if velocity.is_equal_approx(Vector2.ZERO):
		is_walking = false
	else:
		is_walking = true
	
func choose_sex():
	return set_sex(Globals.AGENT_SEX.values()[randi() % 2])
		
func set_sex(value):
	sex = value
	
	if is_inside_tree():
		set_color_by_sex()

func set_color_by_sex():
	if sex == Globals.AGENT_SEX.A:
		$Torso.modulate = Globals.COLOR_SEX_A
	elif sex == Globals.AGENT_SEX.B:
		$Torso.modulate = Globals.COLOR_SEX_B
		
# TODO: This needs to be synchronized
func process_metabolic_costs(delta):
	
	while len(actions) > 0:
		var curr_action = actions.pop_front()
		
#		print("Processing %s" % Globals.AGENT_ACTIONS.keys()[curr_action])
		var energy_cost = 0
		var health_cost = 0
		
		# TODO: Find a more general way of indicating these dependencies
		if curr_action == Globals.AGENT_ACTIONS.WALKING:
			energy_cost += Globals.ENERGY_COST_PER_FRAME[curr_action] * delta * (velocity.length() / MAX_SPEED)
		elif Globals.ENERGY_COST_PER_FRAME.has(curr_action):
			energy_cost += Globals.ENERGY_COST_PER_FRAME[curr_action] * delta
		elif Globals.ENERGY_COST_PER_ACTION.has(curr_action):
			energy_cost += Globals.ENERGY_COST_PER_ACTION[curr_action]
		
		# if not enough energy, subtract the remaining cost from health
		health_cost = max(0, energy_cost - stats.energy)
			
		stats.energy -= energy_cost
		stats.health -= health_cost
		
#		print("Reducing energy by %.2f" % cost)			
		
func disable_all():
	# disable collisions	
	$TorsoCollisionShape.disabled = true
	
	for hair in $Hairs.get_children():
		hair.disable()
	
#	for mandible in $Mandibles.get_children():
#		mandible.disable()
	
	for antenna in $Antennae.get_children():
		antenna.disable()
	
func get_combined_scent(active_scents):
	var combined_scent_sig = Globals.NULL_SMELL

	for id in active_scents.keys():
		var scent = active_scents[id][-1]
		
		var distance = distance_from_scent(scent)
		if distance == null:
			continue
			
#		print('distance: ', distance)
		var scaling_factor = 1 - distance / (Globals.SMELL_DETECTABLE_RADIUS + 250.0)
#		print('scent signature (unscaled): ', scent.signature)
#		print('scaling_factor: ', scaling_factor)
		var scaled_scent = Globals.scale(scent.signature, scaling_factor)
#		print('scent signature (scaled): ', scaled_scent)

		combined_scent_sig = Globals.add_vectors(combined_scent_sig, scaled_scent)
		
	return combined_scent_sig

func get_combined_taste(active_tastes):
	var combined_taste_sig = Globals.NULL_SMELL

	for id in active_tastes.keys():
		var taste = active_tastes[id][-1]
		if taste != null:
			var signature = taste.signature
			if signature != null:
				combined_taste_sig = Globals.add_vectors(combined_taste_sig, signature)

	return combined_taste_sig
				
func get_activity_level():
	
	var combined_scent = get_combined_scent(active_scents)
#	print('combined smell signature: ', combined_scent)
	var level = Globals.get_magnitude(combined_scent)	
	return level

func get_taste_activity_level():
	var combined_taste = get_combined_taste(active_tastes)
#	print('combined taste signature: ', combined_taste)
	var level = Globals.get_magnitude(combined_taste)	
	return level

func init_effectors():
	
	# mandibles
	for mandible in $Mandibles.get_children():
		mandibles.append(mandible)
		
	set_mandible_aperature(mandible_aperature)
	
	# disables the collision detection between mouth and edibles (this is reactivated
	# when the agent attempts an eating action)
	mouth.deactivate()
			
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

		antenna.connect("antenna_detected_taste", self, "_on_antenna_detected_taste")
		antenna.connect("antenna_lost_taste", self, "_on_antenna_lost_taste")
				
		antenna.connect("antenna_detected_object", self, "_on_antenna_detected_object")
		antenna.connect("antenna_lost_object", self, "_on_antenna_lost_object")
		
		sensor_id += 1

func set_rotation(degrees):
	rotation = degrees
	
func set_mandible_aperature(degrees):
	mandibles[0].rotation_degrees = degrees
	mandibles[1].rotation_degrees = -degrees
	
#	print('degrees: ', degrees)

	# counter-intuitively, degrees == 0 when the mandibles are
	# completely open
	if degrees >= 40.0 and len(damageables) > 0:
		process_damage(damageables)

func process_damage(damageables):
	for damageable in damageables:
		damageable.register_damage(Globals.AGENT_ATTACK_DAMAGE)
		
		# additional energy cost from attacking an object
		add_action(Globals.AGENT_ACTIONS.ATTACKING)

# TODO: This needs to be synchronized
func add_action(action):
	if action != null and not actions.has(action):
#		print("New Action: %s" % Globals.AGENT_ACTIONS.keys()[action])
		actions.append(action)		

# TODO: This needs to be synchronized
func remove_action(action):
	var index = actions.find(action)
	if index != -1:
		actions.remove(index)
	
func eat(edible):
#	print("Agent %s attempting to eat %s" % [self,edible])
	if edible == null:
		return

	add_action(Globals.AGENT_ACTIONS.EATING)
	
	# this signal is received by the world scene, which updates both the
	# agent stats and the edible (e.g., the amount that is consumed)
	emit_signal("agent_eating", self, edible)
		
func distance_from_scent(scent):
	if scent == null:
		return null
		
	var distance = Globals.SMELL_DETECTABLE_RADIUS
	
	for antenna in antennae:
		# FIXME: this check is a hack to minimize the number of get_global_transform
		# !is_inside_tree errors that occur after the queue_free that occur when an 
		# agent dies
		if antenna.is_inside_tree():
			var detector_pos = antenna.smell_detector.global_position
		
			# FIXME: this check is a hack to minimize the number of get_global_transform
			# !is_inside_tree errors that occur after the queue_free that occur when fruit 
			# is processed
			if scent.is_inside_tree():
				var scent_pos = scent.global_position		
				distance = min(distance, detector_pos.distance_to(scent_pos))
	
	return distance
	
func add_scent(scent):	
#	print('agent %s smells scent %s with signature %s' % [self, scent, scent.signature])
	
	if active_scents.has(scent.smell_emitter_id):
		active_scents[scent.smell_emitter_id].push_back(scent)
	else:
		active_scents[scent.smell_emitter_id] = [scent]
	
func remove_scent(scent):
#	print('agent %s lost scent %s with signature %s' % [self, scent, scent.signature])
	
	if len(active_scents[scent.smell_emitter_id]) <= 1:
		active_scents.erase(scent.smell_emitter_id)
	else:
		var removed_scent = active_scents[scent.smell_emitter_id].pop_back()

func add_taste(taste):	
#	print('adding: ', taste)
	
	if active_tastes.has(taste.taste_emitter_id):
		active_tastes[taste.taste_emitter_id].push_back(taste)
	else:
		active_tastes[taste.taste_emitter_id] = [taste]
	
func remove_taste(taste):
#	print('removing: ', taste)
	
	if len(active_tastes[taste.taste_emitter_id]) <= 1:
		active_tastes.erase(taste.taste_emitter_id)
	else:
		var removed_taste = active_tastes[taste.taste_emitter_id].pop_back()

func add_damageable_area(area):
	var index_to_area = damageables.find(area)
	
	# not found
	if index_to_area == -1:
		damageables.append(area)
	
func remove_damageable_area(area):
	var index_to_area = damageables.find(area)
	
	# found
	if index_to_area != -1:
		damageables.remove(index_to_area)
			
func is_damageable_area(area):
	var index_to_area = damageables.find(area)	
	return false if index_to_area == -1 else true

###################
# Signal Handlers #
###################
func _on_hair_active(hair):
	active_hairs[hair.id] += 1
	emit_signal("hair_activity_change", active_hairs)

func _on_hair_inactive(hair):
	active_hairs[hair.id] -= 1
	emit_signal("hair_activity_change", active_hairs)

func _on_antenna_detected_smell(antenna, scent):
	if ignored_scents.find(scent) != -1:
#		print('Ignoring scent %s!' % scent )
		return
			
	add_scent(scent)
#	print("Active Smells: ", active_scents.values())
	emit_signal("smell_activity_change", get_activity_level())

func _on_antenna_lost_smell(antenna, scent):
	if ignored_scents.find(scent) != -1:
#		print('Ignoring scent %s!' % scent )
		return
		
	remove_scent(scent)
#	print("Active Smells: ", active_scents.values())
	emit_signal("smell_activity_change", get_activity_level())
	
func _on_antenna_detected_taste(antenna, taste):
	if ignored_tastes.find(taste) != -1:
		return
			
	add_taste(taste)
#	print("Active Tastes: ", active_tastes.values())
	emit_signal("taste_activity_change", get_taste_activity_level())

func _on_antenna_lost_taste(antenna, taste):
	if ignored_tastes.find(taste) != -1:
		return
		
	remove_taste(taste)
#	print("Active Tastes: ", active_tastes.values())
	emit_signal("taste_activity_change", get_taste_activity_level())
	
func _on_antenna_detected_object(antenna, body):
	active_antennae[antenna.id] += 1
	emit_signal("antennae_activity_change", active_antennae)
	
func _on_antenna_lost_object(antenna, body):
	active_antennae[antenna.id] -= 1
	emit_signal("antennae_activity_change", active_antennae)
	
func _on_detected_damageable(area):
#	print("_on_detected_damageable: ", area)
	add_damageable_area(area)
#	print('damageables: ', damageables)

func _on_lost_damageable(area):
#	print("_on_lost_damageable: ", area)
	remove_damageable_area(area)
#	print('damageables: ', damageables)	

func _on_detected_edible(area):
	var edible = area.get_owner()
#	print("AgentAbstract._on_detected_edible: ", edible)
	
	eat(edible)

func _on_mouth_consumed_edible(edible):
	if edible == null:
		return

	# edible corresponds to a child of a food, so we get the owner
	# to get its parent
	emit_signal("agent_eating", self, edible.get_owner())

func _on_received_physical_damage(amount):
	hit_effect.visible = true
	hit_effect.play()
#	print("%s received %f points of physical damage" % [self, amount])
	stats.health -= amount

func _on_agent_dead():
	emit_signal("agent_dead", self)

func _on_hit_animation_finished():
	hit_effect.visible = false
