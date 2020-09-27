# gdscript: agent-stats.gd

extends Node2D

#############
# constants #
#############
const MAX_HEALTH = 10
const MAX_ENERGY = 50
const MAX_SATIETY = 100

enum SEX {
	A,
	B
}

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
	
	health = MAX_HEALTH
	energy = MAX_ENERGY
	satiety = MAX_SATIETY
	
func set_health(value):
	health = value
	
	if health <= 0:
		# this should be received/handled by the environment, as there
		# are many things that must occur when an agent dies
		emit_signal("death", agent)
	
func set_energy(value):
	energy = value

func set_satiety(value):
	satiety = value

func choose_sex():
	return SEX.values()[randi() % 2] 
	
