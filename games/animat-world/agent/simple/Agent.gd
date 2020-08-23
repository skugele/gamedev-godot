extends KinematicBody2D

export var MAX_SPEED = 250
export var ACCELERATION = 500
export var FRICTION = 1500

# current velocity
var velocity = Vector2.ZERO

#onready var playerStats = PlayerStats # autoload singleton
#onready var animationPlayer = $AnimationPlayer
#onready var animationTree = $AnimationTree
#onready var animationState = animationTree.get("parameters/playback") 

#onready var swordHitbox = $HitboxPivot/SwordHitbox

#var stats = PlayerStats

# Actions
enum {
	MOVE,
	ATTACK
}

var state = MOVE

#func _ready():
#
#	# connects the no_health signal to the queue_free method of this object
#	playerStats.connect("no_health", self, "queue_free")
#
#	animationTree.active = true
#	swordHitbox.knockback_vector = roll_vector
#
#	stats.max_health = 10	
#	stats.health = 10

# if we need access to the physics details (like position) then we
# need to change this to _physics_process(delta)
func _physics_process(delta):

	move_state(delta)				
	
#	match state:
#		MOVE:
#			move_state(delta)			
#		ATTACK:
#			attack_state(delta)

#func attack_state(delta):
#	velocity = Vector2.ZERO
#
#	# Updates the state of AnimationTree along shortest path
#	animationState.travel("Attack")
#
#func attack_animation_finished():
#	state = MOVE
				
func move_state(delta):
	
	var input_vector = Vector2.ZERO	
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# normalize velocity to be on unit circle
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		# only update the blend position when in motion
#		animationTree.set("parameters/Idle/blend_position", input_vector)
#		animationTree.set("parameters/Run/blend_position", input_vector)
#		animationTree.set("parameters/Attack/blend_position", input_vector)

		# Updates the state of AnimationTree along shortest path
#		animationState.travel("Run")
			
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		# Updates the state of AnimationTree along shortest path
#		animationState.travel("Idle")
		
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
					
	execute_move()
	
	
func execute_move():
	velocity = move_and_slide(velocity)
