# gdscript: agent-stats.gd

extends Node2D

################
# onready vars #
################
onready var agent = self.get_owner()
onready var sex

onready var health setget set_health
onready var energy setget set_energy
onready var satiety setget set_satiety

onready var poison_consumed

#############
# functions #
#############

# Called when the node enters the scene tree for the first time.
func _ready():
	sex = choose_sex()
	
	health = Globals.AGENT_INITIAL_HEALTH
	energy = Globals.AGENT_INITIAL_ENERGY
	satiety = Globals.AGENT_INITIAL_SATIETY
	
	poison_consumed = 0

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
		if not (is_exhausted() or is_poisoned()):
			health += Globals.HEALTH_INCREASE_PER_FRAME * delta
			energy -= Globals.ENERGY_DECREASE_WHILE_HEALING_PER_FRAME * delta
		
	
# TODO: These update functions may need to be synchronized	
func set_health(value):
	health = apply_threshold(value, Globals.AGENT_MAX_HEALTH)
	
func set_energy(value):
	energy = apply_threshold(value, Globals.AGENT_MAX_ENERGY)

func set_satiety(value):
	satiety = apply_threshold(value, Globals.AGENT_MAX_SATIETY)

func apply_threshold(value, high):
	return min(max(0, value), high)
	
func increase_poison_consumed(amount):
	poison_consumed += amount

func decrease_poison_consumed(amount):
	poison_consumed -= amount	

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
			
func choose_sex():
	return Globals.AGENT_SEX.values()[randi() % 2] 
	
