extends GPUParticles3D

func _ready():
	# Connect the 'finished' signal to the 'queue_free' method.
	# This will automatically destroy the node once the particle emission is complete.
	finished.connect(queue_free)