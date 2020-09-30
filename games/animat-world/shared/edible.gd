extends Node2D

signal edible_exhausted

const CONSUMPTION_RATE = 0.1
const MIN_AMOUNT = 0.25

onready var amount_start = 1 setget set_amount_start
onready var amount_left = amount_start setget set_amount_left

func _ready():
	pass # Replace with function body.

func set_amount_start(amount):
	amount_start = max(0, amount)
	
func set_amount_left(amount):
	amount_left = max(0, amount)

func consume():
	var amount_consumed = min(CONSUMPTION_RATE, amount_left)
	
	amount_left -= amount_consumed

	if amount_left <= MIN_AMOUNT:
#		print("Edible exhausted!")

		# TODO: Is this needed, or can we just do a queue_free here?
		emit_signal("edible_exhausted")

	return amount_consumed
