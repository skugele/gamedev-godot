extends Node2D

onready var belly = $Belly
onready var torso = $Torso
onready var stats = $Stats

onready var leg_animator = $Legs/LegAnimationPlayer

export(String) var id = null
export(Globals.AGENT_SEX) var sex = null

func _ready():
	
	if sex == Globals.AGENT_SEX.A or sex == null:
		torso.modulate = Globals.COLOR_SEX_A
	elif sex == Globals.AGENT_SEX.B:
		torso.modulate = Globals.COLOR_SEX_B
	else:
		torso.modulate = Color(0,0,0,1)
	
	leg_animator.playback_speed = 1.5
	leg_animator.play("DeathIdle")
	
	disable_all()

func init_from_agent(agent):
	id = agent.id
	sex = agent.sex
	
	global_position = agent.global_position
	rotation = agent.rotation

func disable_all():
	for hair in $Hairs.get_children():
		hair.disable()
	
	for mandible in $Mandibles.get_children():
		mandible.disable()
	
	for antenna in $Antennae.get_children():
		antenna.disable()

	$DamageableDetector/CollisionShape2D.disabled = true
	$Mouth/Area2D/CollisionShape2D.disabled = true
	$Damageable/DamageZone/CollisionShape2D.disabled = true
	
	
