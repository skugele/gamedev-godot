extends Node2D

export(Globals.CHEMO_SIGNAL_TYPES) var signal_type = null setget set_signal_type

onready var sprite = $Sprite
onready var smell = $Smell
onready var taste = $Taste
onready var scent_areas = $Smell/ScentAreas
onready var taste_areas = $Taste/TasteAreas

onready var signature = null

var amount = 0.0 setget set_amount

# Called when the node enters the scene tree for the first time.
func _ready():
	init_for_type()
	init_scent_areas([25, 100, 250, 500, 1000])
	init_taste_areas()

func set_signal_type(type):
	signal_type = type
	
func set_amount(value):
	amount = value

func init_for_type():
	
	# null is included here because the first enum value is set as null from the editor
	# instead of an integer value of zero (so basically, it's a hack to work around that issue)
	if signal_type in [Globals.CHEMO_SIGNAL_TYPES.AGGREGATION, null]:
		sprite.modulate = Globals.CHEMO_AGGREGATION_COLOR
		signature = Globals.add_vector_array([Globals.CHEMICAL_SIGNAL_SMELL, Globals.CHEMO_AGGREGATION_SMELL])
	elif signal_type == Globals.CHEMO_SIGNAL_TYPES.ALARM:
		sprite.modulate = Globals.CHEMO_ALARM_COLOR
		signature = Globals.add_vector_array([Globals.CHEMICAL_SIGNAL_SMELL, Globals.CHEMO_ALARM_SMELL])
	elif signal_type == Globals.CHEMO_SIGNAL_TYPES.SEXUAL:
		sprite.modulate = Globals.CHEMO_SEXUAL_COLOR
		signature = Globals.add_vector_array([Globals.CHEMICAL_SIGNAL_SMELL, Globals.CHEMO_SEXUAL_SMELL])
	elif signal_type == Globals.CHEMO_SIGNAL_TYPES.TRAIL:
		sprite.modulate = Globals.CHEMO_TRAIL_COLOR
		signature = Globals.add_vector_array([Globals.CHEMICAL_SIGNAL_SMELL, Globals.CHEMO_TRAIL_SMELL])
	else:
		printerr("Unrecognized chemo-type %s" % signal_type)
	
	# these will only appear in DEBUG mode where collision shapes are visible
	scent_areas.modulate = sprite.modulate
	taste_areas.modulate = sprite.modulate
		
func init_scent_areas(radii):
	for r in radii:
		smell.add_scent_area(r, signature)	

func init_taste_areas():
	taste.set_signature(signature)
