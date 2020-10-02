# gdscript: agent-info-display.gd

extends CanvasLayer

# agent sensor activity alerts
onready var hair_alerts = []
onready var antennae_alerts = []

onready var agent_body = $Panel/AgentInfoPanel/BodyPanel/Agent

# agent info
onready var agent_id = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Info/GridContainer/Values/ID
onready var agent_sex = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Info/GridContainer/Values/Sex

# Group 1 (Resources)
onready var agent_health = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Status/GridContainer/Resources/Bars/Health/Bar
onready var agent_energy = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Status/GridContainer/Resources/Bars/Energy/Bar
onready var agent_satiety = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Status/GridContainer/Resources/Bars/Satiety/Bar

# Group 2 (Location and Speed)
onready var agent_pos = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Status/GridContainer/General1/Values/Position
onready var agent_speed = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Status/GridContainer/General1/Values/Speed

# Group 3 (Other)
onready var agent_poison_consumed = $Panel/AgentInfoPanel/StatsPanel/TabContainer/Status/GridContainer/General2/Values/PoisonConsumed


var current_agent = null setget set_agent

func _ready():
	init_sensor_alerts()
	
	# initialize ui elements
	$Panel/AgentInfoPanel/StatsPanel/TabContainer.set_tab_title(0, "Status")
	$Panel/AgentInfoPanel/StatsPanel/TabContainer.set_tab_title(1, "Info")
	
	# init agent status bars
	agent_health.max_value = Globals.AGENT_MAX_HEALTH
	agent_energy.max_value = Globals.AGENT_MAX_ENERGY
	agent_satiety.max_value = Globals.AGENT_MAX_SATIETY
	
func _process(delta):
	# sets the elapsed time string on the display
	$SidePanel/ElapsedTime.text = Globals.TIME_FORMAT_STRING % Globals.get_elapsed_time()

	if current_agent == null:	
		$Panel.visible = false		
	else:
		$Panel.visible = true
		
		# update agent info
		agent_id.text = str(current_agent.id)
		agent_sex.text = Globals.get_sex_as_string(current_agent.stats.sex)
		agent_pos.text = "(%.2f, %.2f)" % [current_agent.global_position.x, current_agent.global_position.y]
		agent_speed.text = "%.2f" % current_agent.velocity.length()
		agent_poison_consumed.text = "%.2f" % current_agent.stats.poison_consumed
		
			
		# update agent status
		agent_health.value = current_agent.stats.health
		agent_energy.value = current_agent.stats.energy
		agent_satiety.value = current_agent.stats.satiety
	
	
func set_agent(agent):
	current_agent = agent
		
func init_sensor_alerts():
	var container = $Panel/AgentInfoPanel/BodyPanel/Agent/StatusOverlay/HairAlerts
	for hair in container.get_children():
		hair.set_inactive()	
		hair_alerts.append(hair)
		
	container = $Panel/AgentInfoPanel/BodyPanel/Agent/StatusOverlay/AntennaeAlerts
	for antenna_alert in container.get_children():
		antenna_alert.set_smell_activity_level(0)
		
		antennae_alerts.append(antenna_alert)
		
	$Panel/AgentInfoPanel/BodyPanel/Agent/Torso.modulate = Color(0,0,0,1.0)
			
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
		
func _on_agent_taste_activity_change(level):
	for alert in antennae_alerts:
		alert.set_taste_activity_level(level)

func _on_agent_antennae_activity_change(activity):
#	print('in _on_agent_antennae_activity_change:', activity)
	var id = 0
	for a in activity:
		if a > 0:
			antennae_alerts[id].set_touch_active()
		else:
			antennae_alerts[id].set_touch_inactive()
		id += 1
