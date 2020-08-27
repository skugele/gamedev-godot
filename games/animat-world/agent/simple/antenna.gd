extends Node2D

signal antenna_detected_smell(antenna, sensory_data)
signal antenna_lost_smell(antenna, sensory_data)

# unique identifier for this antenna
export(int) var id = -1

func _ready():
	pass # Replace with function body.
			
func _on_smell_detected(sensory_data):
	emit_signal("antenna_detected_smell", self, sensory_data)

func _on_smell_lost(sensory_data):
	emit_signal("antenna_lost_smell", self, sensory_data)
