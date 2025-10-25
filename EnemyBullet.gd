extends Area3D

@export var speed = 8.0
var damage = 5 # As requested, 5 points of damage

func _physics_process(delta):
	position.y -= speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	# CORREÇÃO: Usar object pooling
	visible = false
	BulletPool.return_enemy_bullet(self)

func _on_screen_exited():
	visible = false
	BulletPool.return_enemy_bullet(self)
