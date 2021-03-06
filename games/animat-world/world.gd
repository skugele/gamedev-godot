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
	create_world()
	agent_join(Globals.generate_unique_id())

func _physics_process(delta):
	pass

func _input(event):	
	if event.is_action_pressed("ui_zoom_in"):
		zoom_in()
	elif event.is_action_pressed("ui_zoom_out"):
		zoom_out()
		
	if event.is_action_pressed("toggle_mask"):
		agent_info_display.toggle_mask_visibility()
		
func create_random_objects():
		
	for i in range(Globals.N_RANDOM_TREES):
		create_objects("res://objects/simple/tree.tscn", 
			[Vector2(rand_range(Globals.WORLD_HORIZ_EXTENT[0], Globals.WORLD_HORIZ_EXTENT[1]), 
					 rand_range(Globals.WORLD_VERT_EXTENT[0], Globals.WORLD_VERT_EXTENT[1]))], 
			$Trees)

	for i in range(Globals.N_RANDOM_ROCKS):
		create_objects("res://objects/simple/rock-obstacle.tscn", 
			[Vector2(rand_range(Globals.WORLD_HORIZ_EXTENT[0], Globals.WORLD_HORIZ_EXTENT[1]),
					 rand_range(Globals.WORLD_VERT_EXTENT[0], Globals.WORLD_VERT_EXTENT[1]))], 
			$Rocks)

	# this should never print anything. if it does, then there may be a memory leak
	print_stray_nodes()	
		
func create_world():

	# TODO: Load objects from a saved world file (e.g., a JSON file)
#	load_objects()
	
	if Globals.RANDOMIZED:
		create_random_objects()	
		
	# installs signal handlers
	for node in $UnprocessedFood.get_children():
		add_fruit_signal_handlers(node)

	for node in $Eggs.get_children():
		add_egg_signal_handlers(node)
		
	for node in $Trees.get_children():
		add_tree_signal_handlers(node)
		
	for node in $Agents.get_children():
		add_agent_signal_handlers(node)	

func create_objects(scene, locations, parent):
	for loc in locations:
		var obj = load(scene).instance()
		obj.position = loc
		obj.visible = false

		# the node must be added to the scene tree before collision detection or
		# the following error will occur: 
		# ---> ERROR: get_global_transform: Condition "!is_inside_tree()" is true. Returned: get_transform()
		parent.add_child(obj)
			
		# check for collision with existing object
		if has_collision(obj):
			obj.free()
		else:
			obj.visible = true	

func has_collision(obj):
	var space_rid = get_world_2d().space
	var space_state = Physics2DServer.space_get_direct_state(space_rid)

	var shape = obj.get_node("CollisionShape2D").shape

	# translates shape's location to the object's global position
	var transform = Transform2D()
	transform.origin = obj.global_position
		
	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(shape)
	query.set_transform(transform)
	query.set_exclude([obj])
	query.collision_layer = Globals.FIXED_OBJECTS_LAYER | Globals.MANIPULATABLE_OBJECTS_LAYER | Globals.AGENTS_LAYER

	var results = space_state.intersect_shape(query, 1)
	
#	for result in results:
#		print(result)

	return len(results) > 0
		
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

func add_fruit(location, type):
		
	var scene = null
	var node = null
	
	if type == Globals.FOOD_TYPES.GOOD:
		scene = load("res://objects/simple/food-good.tscn")
	elif type == Globals.FOOD_TYPES.BAD:
		scene = load("res://objects/simple/food-bad.tscn")
			
	node = scene.instance()
	node.global_position = location
	node.visible = false
	
	# the node must be added to the scene tree before collision detection or
	# the following error will occur: 
	# ---> ERROR: get_global_transform: Condition "!is_inside_tree()" is true. Returned: get_transform()
	$UnprocessedFood.add_child(node)	
		
	if has_collision(node):
#		print("Collision detected!")
		node.queue_free()
	else:	
		# add new fruit node to scene
		node.visible = true
		add_fruit_signal_handlers(node)

func add_agent_signal_handlers(node):
	node.connect(
		"agent_eating", 
		self, 
		"_on_agent_eating_edible")		
		
	node.connect(
		"agent_selected",
		self,
		"_on_agent_selected"
	)	

	node.connect(
		"agent_dead",
		self,
		"_on_agent_dead"
	)	

	node.connect(
		"agent_chemical_signal",
		self,
		"_on_agent_chemical_signal"
	)	
	
func add_egg_signal_handlers(node):
	node.connect(
		"destroyed_egg", 
		self, 
		"_transform_egg_to_food")

func add_fruit_signal_handlers(node):
	node.connect(
		"destroyed_fruit", 
		self, 
		"_transform_fruit")

func add_tree_signal_handlers(node):
	node.connect(
		"drop_fruit", 
		self, 
		"_handle_dropped_fruit")
	
func agent_join(id):
	var agent = load("res://agent/simple/agent-human-controlled.tscn")
	var agent_node = agent.instance()
	
	agents.add_child(agent_node)
	agent_node.id = id
	
	# TODO: Need to add logic to randomly assign a starting location
	agent_node.global_position.x = 815
	agent_node.global_position.y = -1240
	agent_node.rotation = 30
	
	add_agent_signal_handlers(agent_node)
	
	# adds camera to agent
	camera = Camera2D.new()
	camera.current = true
	camera.zoom = Vector2(DEFAULT_ZOOM, DEFAULT_ZOOM)
	
	camera.smoothing_enabled = Globals.CAMERA_SMOOTHING_ENABLED
	if Globals.CAMERA_SMOOTHING_ENABLED:
		camera.smoothing_speed = Globals.CAMERA_SMOOTHING_SPEED

	agent_node.add_child(camera)
	
	return agent_node

func update_agent_stats_from_eating(agent, edible, amount):
	if edible == null or amount <= 0:
		return
		
	# satiety is always increased after consuming edibles
	agent.stats.satiety += amount * Globals.SATIETY_PER_UNIT_FOOD
	
	if not agent.stats.is_full():
		agent.stats.energy += Globals.ENERGY_PER_UNIT_FOOD
		
	if edible.is_bad():
		agent.stats.poison_consumed += amount
	
###################
# Signal Handlers #
###################
func _handle_dropped_fruit(tree, type):
#	print("handling dropped fruit event")
	
	var location = tree.global_position	
	var location_permutation = Vector2(rand_range(-1.0, 1.0), 
									   rand_range(-1.0, 1.0)).normalized() * Globals.FRUIT_DROP_DISTANCE_FROM_TREE
		
	location.x += location_permutation.x
	location.y += location_permutation.y
	
	add_fruit(location, type)
						
func _transform_fruit(fruit):
#	print('Transforming fruit node: ', fruit)	
	
	# create new processed food node
	var scene = null
	if fruit.is_good():
		scene = load("res://objects/simple/processed-food-good.tscn")
	elif fruit.is_bad():
		scene = load("res://objects/simple/processed-food-bad.tscn")
		
	var obj = scene.instance()
	
	# set its location to the location of the unprocessed food node
	obj.init_from_unprocessed_food(fruit)
			
	# FIXME: this check is a hack to minimize the number of get_global_transform
	# !is_inside_tree errors that occur after the queue_free that occur when fruit 
	# is processed
	fruit.call_deferred("queue_free")
	
	# add new unprocessed node to scene
	$ProcessedFood.add_child(obj)
	
func _transform_egg_to_food(egg):
#	print('Transforming egg node into food: ', egg)	
	
	# create new processed food node
	var scene = null
	scene = load("res://objects/simple/processed-food-egg.tscn")
		
	var obj = scene.instance()
	
	# set its location to the location of the unprocessed food node
	obj.init_from_egg(egg)
			
	# FIXME: this check is a hack to minimize the number of get_global_transform
	# !is_inside_tree errors that occur after the queue_free that occur when fruit 
	# is processed
	egg.call_deferred("queue_free")
	
	# add new unprocessed node to scene
	$ProcessedFood.add_child(obj)
	
func _on_agent_eating_edible(agent, edible):
	var amount_consumed = edible.consume()
	
#	print("Agent %s ate %s portions of %s" % [agent, amount_consumed, edible])
	
	update_agent_stats_from_eating(agent, edible, amount_consumed)
		
	# TODO: update agent's stats based on item consumed and amount consumed
	
func _on_agent_selected(agent):
	if agent == agent_info_display.current_agent:
		agent_info_display.current_agent = null
	else:
		agent_info_display.current_agent = agent
		
	# set of activity signal handlers
	agent.connect(
		"hair_activity_change", 
		agent_info_display, 
		"_on_agent_hair_activity_change")
		
	agent.connect(
		"smell_activity_change", 
		agent_info_display, 
		"_on_agent_smell_activity_change")		

	agent.connect(
		"taste_activity_change", 
		agent_info_display, 
		"_on_agent_taste_activity_change")		
				
	agent.connect(
		"antennae_activity_change", 
		agent_info_display, 
		"_on_agent_antennae_activity_change")
		
func _on_agent_dead(agent):
	print("Agent %s is dead!" % agent.id)
	
	# create new dead agent node
	var scene = load("res://agent/simple/dead-agent.tscn")	
	var dead_agent = scene.instance()
	
	# set its location to the location of the unprocessed food node
	dead_agent.init_from_agent(agent)
	
	# FIXME: attach camera to world?
					
	# add new dead agent to scene
	$DeadAgents.add_child(dead_agent)

	# FIXME: this check is a hack to minimize the number of get_global_transform
	# !is_inside_tree errors that occur after the queue_free that occur when fruit 
	# is processed
	agent.call_deferred("queue_free")
	
func _on_agent_chemical_signal(agent, chemical_signal):
	var scene = load("res://shared/chemical-signal.tscn")	
	var obj = scene.instance()
	obj.signal_type = chemical_signal
	
	obj.global_position = agent.pheromone_emitter.global_position
	
	$ChemoSignals.add_child(obj)
	
