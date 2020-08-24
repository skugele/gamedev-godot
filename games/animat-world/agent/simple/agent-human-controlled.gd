extends "res://agent/simple/agent-abstract.gd"

func get_input():
	var turn = 0
	var direction = Vector2.ZERO
	var mandible_change_dir = 0

	# forward/backward motion
	if Input.is_action_pressed("ui_forward"):
		direction = Vector2(0, -1).rotated(rotation)
	elif Input.is_action_pressed("ui_backward"):
		direction = Vector2(0, 1).rotated(rotation)

	# body rotation
	if Input.is_action_pressed("ui_turn_right"):
		turn += 1
	elif Input.is_action_pressed("ui_turn_left"):
		turn -= 1
		
	# mandible aperature
	if Input.is_action_pressed("ui_open_mandibles"):
		mandible_change_dir = 1
	elif Input.is_action_pressed("ui_close_mandibles"):
		mandible_change_dir = -1
		
	return [direction, turn, mandible_change_dir]
	
func execute_move(inputs, delta):
	var direction = inputs[0]
	var turn = inputs[1]
	var mandible_change_dir = inputs[2]
	
	# execute forward/backward motion
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
	# apply friction
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	# execute body rotation
	rotation += turn * MAX_ROTATION * delta
	
	# execute mandible change
	if mandible_change_dir != 0:
		update_mandible_aperature(mandible_change_dir, delta)
	
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	var inputs = get_input()
	execute_move(inputs, delta)	
