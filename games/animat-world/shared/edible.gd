extends Node2D

signal edible_exhausted

# TODO: Move this to an export or other settable variable
const CONSUMPTION_RATE = 0.25

var amount_left = 1 setget set_amount_left

func _ready():
	pass # Replace with function body.

func set_amount_left(amount):
	amount_left = max(0, amount)

func consume():
	var amount_consumed = min(CONSUMPTION_RATE, amount_left)
	
	amount_left -= amount_consumed

	if amount_left == 0:
#		print("Edible exhausted!")

		# TODO: Is this needed, or can we just do a queue_free here?
		emit_signal("edible_exhausted")

	return amount_consumed
