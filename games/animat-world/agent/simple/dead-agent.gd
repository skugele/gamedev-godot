extends Node2D

onready var belly = $Belly
onready var torso = $Torso
onready var stats = $Stats

onready var leg_animator = $Legs/LegAnimationPlayer

func _ready():
	
	if stats.sex == Globals.AGENT_SEX.A:
		torso.modulate = Globals.COLOR_SEX_A
	elif stats.sex == Globals.AGENT_SEX.B:
		torso.modulate = Globals.COLOR_SEX_B
	
	leg_animator.playback_speed = 1.5
	leg_animator.play("DeathIdle")

