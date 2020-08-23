extends "res://agent/simple/agent-abstract.gd"

func get_input():
	var turn = 0
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_forward"):
		direction = Vector2(0, -1).rotated(rotation)
	elif Input.is_action_pressed("ui_backward"):
		direction = Vector2(0, 1).rotated(rotation)

	if Input.is_action_pressed("ui_turn_right"):
		turn += 1
	elif Input.is_action_pressed("ui_turn_left"):
		turn -= 1
		
	return [direction, turn]
	
func execute_move(inputs, delta):
	var direction = inputs[0]
	var turn = inputs[1]
	
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	rotation += turn * MAX_ROTATION * delta
	
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	var inputs = get_input()
	execute_move(inputs, delta)	
