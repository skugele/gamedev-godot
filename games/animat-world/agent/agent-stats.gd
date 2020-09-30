# gdscript: agent-stats.gd

extends Node2D

################
# onready vars #
################
onready var sex # SEX_A or SEX_B
onready var health setget set_health
onready var energy setget set_energy
onready var satiety setget set_satiety

onready var agent = self.get_owner()

###########
# signals #
###########
signal death(agent)

#############
# functions #
#############

# Called when the node enters the scene tree for the first time.
func _ready():
	sex = choose_sex()
	
	health = Globals.AGENT_INITIAL_HEALTH
	energy = Globals.AGENT_INITIAL_ENERGY
	satiety = Globals.AGENT_INITIAL_SATIETY
	
func set_health(value):
	
	health = min(value, Globals.AGENT_MAX_HEALTH)
	health = max(0, health)
	
	if health <= 0:
		# this should be received/handled by the environment, as there
		# are many things that must occur when an agent dies
		emit_signal("death", agent)
	
func set_energy(value):
	energy = min(value, Globals.AGENT_MAX_ENERGY)
	energy = max(0, energy)

func set_satiety(value):
	satiety = min(value, Globals.AGENT_MAX_SATIETY)
	satiety = max(0, satiety)
		
	# TODO: if starving (satiety == 0):start a timer that continues to periodically damage
	# the agent until satiety > 0 (stop timer)
	
func choose_sex():
	return Globals.AGENT_SEX.values()[randi() % 2] 
	
