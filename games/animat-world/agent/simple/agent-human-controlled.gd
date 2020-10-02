# gdscript: agent-human-controlled.gd

extends "res://agent/simple/corporeal-agent.gd"

#func _ready():		
#	pass

func _physics_process(delta):
	var inputs = get_input()
	execute_move(inputs, delta)	
	
func get_input():
	var turn = 0
	var direction = Vector2.ZERO
	var mandible_change_dir = 0

	# forward/backward motion
	if Input.is_action_pressed("ui_forward"):
		add_action(Globals.AGENT_ACTIONS.WALKING_FORWARD)
		direction = Vector2(0, -1).rotated(rotation)
	elif Input.is_action_pressed("ui_backward"):
		add_action(Globals.AGENT_ACTIONS.WALKING_BACKWARD)
		direction = Vector2(0, 1).rotated(rotation)

	# body rotation
	if Input.is_action_pressed("ui_turn_right"):
		add_action(Globals.AGENT_ACTIONS.TURNING_RIGHT)
		turn += 1
	elif Input.is_action_pressed("ui_turn_left"):
		add_action(Globals.AGENT_ACTIONS.TURNING_LEFT)
		turn -= 1
		
	# mandible aperature
	if Input.is_action_pressed("ui_open_mandibles"):
		add_action(Globals.AGENT_ACTIONS.OPENING_MANDIBLES)
		mandible_change_dir = -1
	elif Input.is_action_pressed("ui_close_mandibles"):
		add_action(Globals.AGENT_ACTIONS.CLOSING_MANDIBLES)
		mandible_change_dir = 1

	# eating 
	# ---> using is_action_just_pressed so it will only trigger once per press
	if Input.is_action_just_pressed("ui_eat"):
		add_action(Globals.AGENT_ACTIONS.EXTENDING_TONGUE)
		mouth.activate()
	elif Input.is_action_just_released("ui_eat"):
		mouth.deactivate()
				
	return [direction, turn, mandible_change_dir]
	
func execute_move(inputs, delta):
	var direction = inputs[0]
	var turn = inputs[1]
	var mandible_change_dir = inputs[2]
	
	# execute forward/backward motion
	if direction != Vector2.ZERO:
		update_velocity(direction, delta)
	else:
		# apply friction
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	# execute body rotation
	if turn != 0:
		update_rotation(turn, delta)
	
	# execute mandible change
	if mandible_change_dir != 0:
		update_mandible_aperature(mandible_change_dir, delta)
	
	velocity = move_and_slide(velocity)

func update_velocity(direction, delta):
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	emit_signal("velocity_change", velocity)
		
func update_rotation(turn, delta):
	rotation += turn * MAX_ROTATION * delta	
	emit_signal("rotation_change", rotation)
		
func update_mandible_aperature(change_dir, delta):
	var value = mandibles[0].rotation_degrees \
			  + change_dir * APERATURE_ACCELERATION * delta

	if value >= 0 and value <= MAX_MANDIBLE_APERATURE_IN_DEGREES:
		set_mandible_aperature(value)
		emit_signal("mandible_aperture_change", value)

