extends CanvasLayer

# boolean alerts
onready var hair_alerts = []

# scalar alerts
onready var antennae_alerts = []


onready var agent_body = $Panel/Background/BodyPanel/AgentDummy

func _ready():
	init_sensor_alerts()

func init_sensor_alerts():
	
	var container = $Panel/Background/BodyPanel/AgentDummy/StatusOverlay/ActiveHairAlerts
	for hair in container.get_children():
		hair.set_inactive()	
		hair_alerts.append(hair)
		
	container = $Panel/Background/BodyPanel/AgentDummy/StatusOverlay/ActiveAntennaeAlerts
	for antenna in container.get_children():
		antenna.set_activity_level(0)
		antennae_alerts.append(antenna)
			
func _on_agent_hair_activity_change(active_hairs):
	var id = 0
	for hair_active in active_hairs:
		if hair_active:
			hair_alerts[id].set_active()
		else:
			hair_alerts[id].set_inactive()
		id += 1

# TODO: This needs to trigger the walking animation later once legs are added
func _on_agent_velocity_change(value):
	pass
	
func _on_agent_rotation_change(value):
	agent_body.set_rotation(value)
	
func _on_agent_mandible_aperture_change(value):
	agent_body.set_mandible_aperature(value)
	
func _on_agent_smell_activity_change(smell_activity):
	print("destination reached! ", smell_activity)
	for i in len(smell_activity):
		antennae_alerts[i].set_activity_level(smell_activity[i])
