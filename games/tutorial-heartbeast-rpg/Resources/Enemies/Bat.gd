extends KinematicBody2D

export var REBOUND = 200
export var KNOCKBACK = 150

var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, REBOUND * delta)
	knockback = move_and_slide(knockback)
	
func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * KNOCKBACK