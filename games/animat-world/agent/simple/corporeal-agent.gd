extends "res://agent/simple/agent-abstract.gd"

onready var damageables = []

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
	
func add_damageable_area(area):
	var index_to_area = damageables.find(area)
	
	# not found
	if index_to_area == -1:
		damageables.append(area)
	
func remove_damageable_area(area):
	var index_to_area = damageables.find(area)
	
	# found
	if index_to_area != -1:
		damageables.remove(index_to_area)
		
func is_damageable_area(area):
	var index_to_area = damageables.find(area)
	
	return false if index_to_area == -1 else true

func _on_detected_damageable(area):
	print("_on_detected_damageable: ", area)
	add_damageable_area(area)
	print('damageables: ', damageables)

func _on_lost_damageable(area):
	print("_on_lost_damageable: ", area)
	remove_damageable_area(area)
	print('damageables: ', damageables)	
