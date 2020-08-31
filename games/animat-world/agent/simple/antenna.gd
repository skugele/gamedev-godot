# gdscript: antenna.gd

extends Node2D

signal antenna_detected_smell(antenna, scent)
signal antenna_lost_smell(antenna, scent)
signal antenna_detected_object(antenna, body)
signal antenna_lost_object(antenna, body)

onready var smell_detector = $SmellDetector

# unique identifier for this antenna
export(int) var id = -1

func enable():
	$SmellDetector.enable()
	$TouchDetector/CollisionShape2D.disabled = false

func disable():
	$SmellDetector.disable()
	$TouchDetector/CollisionShape2D.disabled = true

func _on_smell_detected(scent):
	emit_signal("antenna_detected_smell", self, scent)

func _on_smell_lost(scent):
	emit_signal("antenna_lost_smell", self, scent)

func _on_touch_detected(body):
#	print('antenna ', id, ' detected object')
	emit_signal("antenna_detected_object", self, body)

func _on_touch_lost(body):
#	print('antenna ', id, ' lost object')
	emit_signal("antenna_lost_object", self, body)
