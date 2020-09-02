extends Area2D

signal register_damage(amount)

func register_damage(amount):
	if amount > 0:
		emit_signal("register_damage", amount)
