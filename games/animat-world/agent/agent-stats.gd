# gdscript: agent-stats.gd

extends Node2D

################
# onready vars #
################
onready var agent = self.get_owner()

var health setget set_health
var energy setget set_energy
var satiety setget set_satiety

var poison_consumed setget set_poison_consumed

###########
# signals #
###########
signal agent_dead

#############
# functions #
#############

# Called when the node enters the scene tree for the first time.
func _ready():
	
	health = Globals.AGENT_INITIAL_HEALTH
	energy = Globals.AGENT_INITIAL_ENERGY
	satiety = Globals.AGENT_INITIAL_SATIETY
	
	poison_consumed = 0.0

func _process(delta):
	
	# satiety decreased
	satiety -= Globals.SATIETY_DECREASE_PER_FRAME * delta
	
	# energy increased
	energy += Globals.ENERGY_INCREASE_PER_FRAME * delta
	
	# if starving
	if is_starving():
		health -= Globals.STARVING_DAMAGE_PER_FRAME * delta
			
	# if poisoned
	if is_poisoned():
		health -= Globals.POISON_DAMAGE_PER_FRAME * delta
		poison_consumed -= Globals.POISON_DECREASE_PER_FRAME * delta	
	
	# if injured
	if is_injured():

		# there is an energy cost to healing 
		# (and no healing when exhaused, starving, or poisoned)		
		if not (is_exhausted() or is_poisoned() or is_starving()):
			health += Globals.HEALTH_INCREASE_PER_FRAME * delta
			energy -= Globals.ENERGY_DECREASE_WHILE_HEALING_PER_FRAME * delta			
			
# TODO: These update functions may need to be synchronized	
func set_health(value):
	health = apply_threshold(value, Globals.AGENT_MAX_HEALTH)
	
	if is_dead():
		emit_signal("agent_dead")
	
func set_energy(value):
	energy = apply_threshold(value, Globals.AGENT_MAX_ENERGY)

func set_satiety(value):
	satiety = apply_threshold(value, Globals.AGENT_MAX_SATIETY)

func set_poison_consumed(value):
	poison_consumed = apply_threshold(value)
	
func apply_threshold(value, high=9999):
	return min(max(0, value), high)
	
func increase_poison_consumed(amount):
	set_poison_consumed(poison_consumed + amount)

func decrease_poison_consumed(amount):
	set_poison_consumed(poison_consumed - amount)

func is_poisoned():
	return poison_consumed > 0

func is_starving():
	return satiety <= 0
	
func is_full():
	return satiety == Globals.AGENT_MAX_SATIETY

func is_injured():
	return health < Globals.AGENT_MAX_HEALTH
		
func is_dead():
	return health <= 0
	
func is_exhausted():
	return energy <= 0

