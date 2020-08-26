extends CanvasLayer

onready var hair_alerts = []
onready var agent_body = $Panel/Background/BodyPanel/AgentDummy

func _ready():
	init_hair_alerts()

func init_hair_alerts():
	var container = $Panel/Background/BodyPanel/AgentDummy/StatusOverlay/ActiveHairAlerts

	# assumes that children are traversed in numerical order
	for hair in container.get_children():
		hair.set_inactive()	
		hair_alerts.append(hair)
		
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
