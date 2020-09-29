extends "res://agent/simple/agent-abstract.gd"

signal agent_selected(agent)

func _ready():
	id = Globals.generate_unique_id()
	
	init_sensors()
	init_effectors()	
	init_agent_smell()
	init_agent_taste()

func init_agent_smell():
	signature = Globals.AGENT_SMELL
	init_scent_areas([100, 250, 500, 1000])

	# build list of ignored smells (i.e., ignore agent's own smells)	
	for area in $Smell/ScentAreas.get_children():
#		print('agent ignoring scent area: ', area)
		ignored_scents.append(area)	

func init_agent_taste():
	init_taste_areas()
	
func init_scent_areas(radii):
	for r in radii:
		$Smell.add_scent_area(r, signature)	
		
func init_taste_areas():
	$Taste.set_signature(signature)
	
func _input_event(viewport, event, shape_idx):

	# This is used to select the agent from the world view
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("agent_selected", self)
