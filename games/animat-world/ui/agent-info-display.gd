extends CanvasLayer

onready var hair_alerts = []

func _ready():
	init_hair_alerts()

func init_hair_alerts():
	var container = $Panel/Background/BodyPanel/StatusOverlay/ActiveHairAlerts

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
