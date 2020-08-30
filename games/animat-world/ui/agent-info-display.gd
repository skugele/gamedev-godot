extends CanvasLayer

# agent sensor activity alerts
onready var hair_alerts = []
onready var antennae_alerts = []

onready var agent_body = $Panel/Background/BodyPanel/Agent

func _ready():
	init_sensor_alerts()

func init_sensor_alerts():
	
	var container = $Panel/Background/BodyPanel/Agent/StatusOverlay/HairAlerts
	for hair in container.get_children():
		hair.set_inactive()	
		hair_alerts.append(hair)
		
	container = $Panel/Background/BodyPanel/Agent/StatusOverlay/AntennaeAlerts
	for antenna_alert in container.get_children():
#		antenna_alert.set_touch_inactive()
		antenna_alert.set_smell_activity_level(0)		
		
		antennae_alerts.append(antenna_alert)
			
func _on_agent_hair_activity_change(activity):
	var id = 0
	for a in activity:
		if a > 0:
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

func _on_agent_smell_activity_change(level):
#	print('_on_agent_smell_activity_change: ', level)
	for alert in antennae_alerts:
		alert.set_smell_activity_level(level)

func _on_agent_antennae_activity_change(activity):
#	print('in _on_agent_antennae_activity_change:', activity)
	var id = 0
	for a in activity:
		if a > 0:
			antennae_alerts[id].set_touch_active()
		else:
			antennae_alerts[id].set_touch_inactive()
		id += 1
