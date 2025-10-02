extends GPUParticles3D

func _ready():
	# The particles are set to one-shot, so we just need to wait until they are finished
	# before destroying the node.
	set_process(true)

func _process(delta):
	if not emitting:
		queue_free()
