extends Area3D

@export var speed = 8.0
var damage = 5 # As requested, 5 points of damage

func _physics_process(delta):
	position.y -= speed * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free() # Destroy the bullet on impact with any physics body


func _on_screen_exited():
	queue_free() # Destroy the bullet when it leaves the screen