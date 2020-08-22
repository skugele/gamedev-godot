extends KinematicBody2D

const EnemyDeathEffect = preload("res://Resources/Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE

export var REBOUND = 50
export var FRICTION = 10000
export var KNOCKBACK = 100

export var MAX_SPEED = 200
export var ACCELERATION = 200

onready var stats = $Stats
onready var sprite = $AnimatedSprite
onready var player_detection_zone = $PlayerDetectionZone
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, REBOUND * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			idle_state(delta)
		WANDER:
			wander_state(delta)
		CHASE:
			chase_state(delta)	
			
	# changes direction bat is facing based on direction of travel	
	sprite.flip_h = velocity.x < 0
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * KNOCKBACK
		
	velocity = move_and_slide(velocity)	
	
# state action handlers
func idle_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	state = get_next_state()
	
func wander_state(delta):
	if wander_controller.get_time_left() == 0:
		wander_controller.start_wander_timer(rand_range(1,3))

	var direction = global_position.direction_to(wander_controller.target_position)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
func get_next_state():
	if player_detection_zone.can_see_player():
		return CHASE
	else:
		var state_list = [WANDER, IDLE]
		state_list.shuffle()
		return state_list.pop_front()
	
func chase_state(delta):
	var player = player_detection_zone.player
	if player != null:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE	

# signal handlers
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK
	
func _on_Stats_no_health():
	var effect = EnemyDeathEffect.instance()

	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	queue_free()

func _on_WanderController_Timer_timeout():
	print("Timeout!")
	state = get_next_state()
