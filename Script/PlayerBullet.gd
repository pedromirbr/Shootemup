extends Area3D

@export var speed = 15.0
var damage = 10 # This will be overwritten by the player when shooting

func _physics_process(delta):
	position.z = PlayerData.GAME_DEPTH
	position.y += speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	# CORREÇÃO: Usar object pooling
	visible = false
	BulletPool.return_player_bullet(self)

func _on_screen_exited():
	visible = false
	BulletPool.return_player_bullet(self)
