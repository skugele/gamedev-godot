extends Node2D

export(float) var MAX_ZOOM_IN = 1
export(float) var  MAX_ZOOM_OUT = 8
export(float) var ZOOM_DELTA = 0.3

const ZOOM_IN_DIRECTION = -1
const ZOOM_OUT_DIRECTION = 1

onready var zoom = MAX_ZOOM_IN

# node aliases
onready var agents = $Agents
onready var camera = null
onready var agent_info_display = $AgentInfoDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	var id = 1
	agent_join(id)

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
	
func agent_join(id):
	var agent = load("res://agent/simple/agent-human-controlled.tscn")
	var agent_node = agent.instance()
	
	agents.add_child(agent_node)
	agent_node.id = id
	agent_node.global_position.x = 125
	agent_node.global_position.y = 500
	
	agent_node.connect("hair_activity_change", self, "_on_agent_hair_activity_change")
	
	# adds camera to agent
	camera = Camera2D.new()
	agent_node.add_child(camera)
	camera.current = true
	
func _on_agent_hair_activity_change(agent):
	print("in _on_agent_hair_activity_change")
	
	
