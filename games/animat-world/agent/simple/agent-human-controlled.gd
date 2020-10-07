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

	# FIXME: this is a hack to allow a different forward and reverse max speed
	var max_speed = 0
	
	# forward/backward motion
	if Input.is_action_pressed("ui_sprint"):
		add_action(Globals.AGENT_ACTIONS.SPRINTING)
		direction = Vector2(0, -1).rotated(rotation)
		max_speed = Globals.AGENT_MAX_SPEED_FORWARD + Globals.AGENT_SPRINTING_MAX_SPEED_BOOST
	elif Input.is_action_pressed("ui_forward"):
		add_action(Globals.AGENT_ACTIONS.WALKING)
		direction = Vector2(0, -1).rotated(rotation)
		max_speed = Globals.AGENT_MAX_SPEED_FORWARD
	elif Input.is_action_pressed("ui_backward"):
		add_action(Globals.AGENT_ACTIONS.WALKING)
		direction = Vector2(0, 1).rotated(rotation)
		max_speed = Globals.AGENT_MAX_SPEED_BACKWARD	
	

	# body rotation
	if Input.is_action_pressed("ui_turn_right"):
		add_action(Globals.AGENT_ACTIONS.TURNING)
		turn += 1
	elif Input.is_action_pressed("ui_turn_left"):
		add_action(Globals.AGENT_ACTIONS.TURNING)
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
				
	return [direction, turn, mandible_change_dir, max_speed]

func execute_move(inputs, delta):
	var direction = inputs[0]
	var turn = inputs[1]
	var mandible_change_dir = inputs[2]
	var max_speed = inputs[3]

	# execute forward/backward motion
	if direction != Vector2.ZERO:
		update_velocity(direction, delta, max_speed)
	else:
		# apply friction
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# execute body rotation
	if turn != 0:
		is_turning = true
		update_rotation(turn, delta)
	else:
		is_turning = false

	# execute mandible change
	if mandible_change_dir != 0:
		update_mandible_aperature(mandible_change_dir, delta)

	velocity = move_and_slide(velocity)
	set_velocity(velocity)

func update_velocity(direction, delta, max_speed):
	velocity = velocity.move_toward(direction * max_speed, ACCELERATION * delta)
	
func update_rotation(turn, delta):
	rotation += turn * MAX_ROTATION * delta

func update_mandible_aperature(change_dir, delta):
	var acceleration = 0

	if change_dir == 1:
		acceleration = Globals.AGENT_MANDIBLE_CLOSING_ACCELERATION
	elif change_dir == -1:
		acceleration = Globals.AGENT_MANDIBLE_OPENING_ACCELERATION

	var value = mandibles[0].rotation_degrees \
			  + change_dir * acceleration * delta

	if value >= 0 and value <= MAX_MANDIBLE_APERATURE_IN_DEGREES:
		set_mandible_aperature(value)
