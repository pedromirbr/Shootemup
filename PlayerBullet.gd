extends Area3D

@export var speed = 15.0
var damage = 10 # This will be overwritten by the player when shooting

func _physics_process(delta):
	position.y += speed * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free() # Destroy the bullet on impact with any physics body


func _on_screen_exited():
	queue_free() # Destroy the bullet when it leaves the screen