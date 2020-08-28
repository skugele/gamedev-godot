extends Node2D

signal antenna_detected_smell(antenna, scent)
signal antenna_lost_smell(antenna, scent)

onready var smell_detector = $SmellDetector

# unique identifier for this antenna
export(int) var id = -1

func _on_smell_detected(scent):
	emit_signal("antenna_detected_smell", self, scent)

func _on_smell_lost(scent):
	emit_signal("antenna_lost_smell", self, scent)
