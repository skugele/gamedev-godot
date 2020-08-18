extends KinematicBody2D

const EnemyDeathEffect = preload("res://Resources/Effects/EnemyDeathEffect.tscn")

export var REBOUND = 200
export var KNOCKBACK = 150

onready var stats = $Stats

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, REBOUND * delta)
	knockback = move_and_slide(knockback)
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK
	
func _on_Stats_no_health():
		# play death animation
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
	queue_free()
