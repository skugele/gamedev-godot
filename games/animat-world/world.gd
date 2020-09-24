# gdscript: world.gd

extends Node2D

export(float) var MAX_ZOOM_IN = 1
export(float) var MAX_ZOOM_OUT = 8
export(float) var DEFAULT_ZOOM = 2
export(float) var ZOOM_DELTA = 0.3

const ZOOM_IN_DIRECTION = -1
const ZOOM_OUT_DIRECTION = 1

onready var zoom = DEFAULT_ZOOM

# node aliases
onready var agents = $Agents
onready var camera = null
onready var agent_info_display = $AgentInfoDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	var id = 1
	create_world()
	agent_join(id)

func _physics_process(delta):
	pass
		
func create_world():

	for food_node in $UnprocessedFood.get_children():
		add_food(food_node)

#	var n_trees = 500
#	for i in range(n_trees):
#		create_object("res://objects/simple/tree.tscn", 
#		[Vector2(rand_range(-2000,1000), 
#				 rand_range(-2000,1000))], 
#		$Trees)
#
#	var locations = [
#		Vector2(1000,1000),
#		Vector2(1001,1001)
#	]
	
#	var n_rocks = 500
#	for i in range(n_rocks):
#		create_object("res://objects/simple/rock-obstacle.tscn", 
#		[Vector2(rand_range(-2000, -1000), 
#				 rand_range(1000, 2000))], 
#		$Rocks)

#	var n_food = 100
#	for i in range(n_food):
#		create_object("res://objects/simple/food-good.tscn",
#		[Vector2(rand_range(-1000, 1000), 
#				 rand_range(-1000, 1000))], 
#		$UnprocessedFood)

	print_stray_nodes()	
	
func create_object(scene, locations, parent):
	for loc in locations:
		var obj = load(scene).instance()
		obj.position = loc
		
		# check for collision with existing object
		if ! has_collision(obj):
			print('Creating %s @ location %s!' % [obj, loc])
			parent.add_child(obj)
		else:
			obj.free()

			print("Collision detected! Skipping object.")

func has_collision(obj):
#	return false

	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)

	var collider = obj.get_node("CollisionShape2D")
	var shape = collider.get_shape()

	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_layer = Globals.FIXED_OBJECTS_LAYER | Globals.MANIPULATABLE_OBJECTS_LAYER | Globals.AGENTS_LAYER
#	query.margin = 5000.0

	var results = space_state.intersect_shape(query)	
	for result in results:
		print(result)

	return len(results) > 0
		
func _input(event):	
	if event.is_action_pressed("ui_zoom_in"):
		zoom_in()
	elif event.is_action_pressed("ui_zoom_out"):
		zoom_out()
		
func zoom_in():
	if camera and zoom - ZOOM_DELTA >= MAX_ZOOM_IN:
		zoom -= ZOOM_DELTA
		update_camera_zoom(ZOOM_IN_DIRECTION)
	
func zoom_out():
	if camera and zoom + ZOOM_DELTA <= MAX_ZOOM_OUT:
		update_camera_zoom(ZOOM_OUT_DIRECTION)
		
func update_camera_zoom(direction):
	zoom += direction * ZOOM_DELTA
	camera.zoom = Vector2(zoom, zoom)

func add_food(food_node):
		
	# connect signals	
	food_node.connect(
		"dead_or_destroyed", 
		self, 
		"_transform_food")
			
func _transform_food(unprocessed_food):
	print('Transforming food node: ', unprocessed_food)	
	
	# create new processed food node
	var scene = null
	if unprocessed_food.is_good():
		scene = load("res://objects/simple/processed-food-good.tscn")
	elif unprocessed_food.is_bad():
		scene = load("res://objects/simple/processed-food-bad.tscn")
		
	var obj = scene.instance()
	
	# set its location to the location of the unprocessed food node
	obj.init_from_unprocessed_food(unprocessed_food)
		
	# free unprocessed food node
	unprocessed_food.queue_free()
	
	# add new unprocessed node to scene
	$ProcessedFood.add_child(obj)
	
func agent_join(id):
	var agent = load("res://agent/simple/agent-human-controlled.tscn")
	var agent_node = agent.instance()
	
	agents.add_child(agent_node)
	agent_node.id = id
	
	# TODO: Need to add logic to randomly assign a starting location
	agent_node.global_position.x = 1000
	agent_node.global_position.y = -1500
	agent_node.rotation = 30
	
	# connect signals
	agent_node.connect(
		"hair_activity_change", 
		agent_info_display, 
		"_on_agent_hair_activity_change")

	agent_node.connect(
		"velocity_change", 
		agent_info_display, 
		"_on_agent_velocity_change")
		
	agent_node.connect(
		"rotation_change", 
		agent_info_display, 
		"_on_agent_rotation_change")
		
	agent_node.connect(
		"mandible_aperture_change", 
		agent_info_display, 
		"_on_agent_mandible_aperture_change")			
		
	agent_node.connect(
		"smell_activity_change", 
		agent_info_display, 
		"_on_agent_smell_activity_change")		

	agent_node.connect(
		"taste_activity_change", 
		agent_info_display, 
		"_on_agent_taste_activity_change")		
				
	agent_node.connect(
		"antennae_activity_change", 
		agent_info_display, 
		"_on_agent_antennae_activity_change")
		
	# adds camera to agent
	camera = Camera2D.new()
	camera.current = true
	camera.zoom = Vector2(DEFAULT_ZOOM, DEFAULT_ZOOM)
	
	camera.smoothing_enabled = Globals.CAMERA_SMOOTHING_ENABLED
	if Globals.CAMERA_SMOOTHING_ENABLED:
		camera.smoothing_speed = Globals.CAMERA_SMOOTHING_SPEED

	agent_node.add_child(camera)
