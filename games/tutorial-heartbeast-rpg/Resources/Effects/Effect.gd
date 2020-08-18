extends AnimatedSprite

func _ready():
	# connects a signal handler at runtime
	connect("animation_finished", self, "_on_animation_finished")	
	play("Animate")

# signal handler for "animation_finished" signal
func _on_animation_finished():
	queue_free()
