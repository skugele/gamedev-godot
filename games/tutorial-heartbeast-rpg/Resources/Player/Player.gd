extends KinematicBody2D

export var MAX_SPEED = 200
export var ACCELERATION = 10
export var FRICTION = 25

# current velocity
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") 

# Actions
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

func _ready():
	animationTree.active = true

func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)						
		ATTACK:
			attack_state(delta)
			
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
		
func roll_state(delta):
	pass
			
func move_state(delta):
	
	var input_vector = Vector2.ZERO	
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# normalize velocity to be on unit circle
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		# only update the blend position when in motion
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		
		animationState.travel("Run")
			
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
					
	velocity = move_and_slide(velocity)
