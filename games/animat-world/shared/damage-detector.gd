extends Area2D

signal detected_damageable(area)
signal lost_damageable(area)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function area.

func _on_damageable_area_entered(area):
#	print("New damageable area: ", area)
	emit_signal("detected_damageable", area)

func _on_damageable_area_exited(area):
#	print("Removing area from damageables: ", area)
	emit_signal("lost_damageable", area)
