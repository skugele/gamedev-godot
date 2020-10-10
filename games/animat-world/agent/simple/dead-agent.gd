extends Node2D

onready var belly = $Belly
onready var torso = $Torso
onready var stats = $Stats

onready var leg_animator = $Legs/LegAnimationPlayer
onready var hit_effect = $HitEffect

export(String) var id = null
export(Globals.AGENT_SEX) var sex = null

var signature = null

func _ready():
	var scent_attributes = [Globals.AGENT_SMELL,
							Globals.ADULT_AGENT_SMELL,
							Globals.DEAD_AGENT_SMELL]

	if sex == Globals.AGENT_SEX.A or sex == null:
		scent_attributes.append(Globals.SEX_A_AGENT_SMELL)							
		torso.modulate = Globals.COLOR_SEX_A
	elif sex == Globals.AGENT_SEX.B:
		scent_attributes.append(Globals.SEX_B_AGENT_SMELL)
		torso.modulate = Globals.COLOR_SEX_B
	else:
		printerr("Unknown sex encountered: ", sex)				
		
	signature = Globals.add_vector_array(scent_attributes)
		
	leg_animator.playback_speed = 1.5
	leg_animator.play("DeathIdle")
	
	hit_effect.frame = 0
	
	disable_all()

func init_from_agent(agent):
	id = agent.id
	sex = agent.sex
	global_position = agent.global_position
	rotation = agent.rotation
	
	signature = Globals.add_vectors(agent.signature, Globals.DEAD_AGENT_SMELL)

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
	
	
