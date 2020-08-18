extends AnimatedSprite

func _ready():
	# connects a signal handler at runtime
	self.connect("animation_finished", self, "_on_animation_finished")	
	frame = 0
	play("Animate")

# signal handler for "animation_finished" signal
func _on_animation_finished():
	queue_free()
