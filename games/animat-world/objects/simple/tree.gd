extends StaticBody2D

onready var fruit_drop_timer = $DropTimer
onready var fruit_type

# signals
signal drop_fruit(tree, fruit_type)

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = rand_range(0,360)

	if not Globals.STATIC:
		$DropTimer.wait_time = rand_range(Globals.FRUIT_DROP_RATE_RANGE[0], Globals.FRUIT_DROP_RATE_RANGE[1])
		$DropTimer.start()

	# trees generate fruit of a single type
	fruit_type = randi() % len(Globals.FOOD_TYPES.values())

func _on_drop_event():
#	print("%s is dropping fruit!" % self)

	emit_signal("drop_fruit", self, fruit_type)
