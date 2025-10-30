extends CharacterBody3D

@export var speed = 3.0
@export var health = 10
var max_health: int

var bullet_scene = preload("res://Scene/EnemyBullet.tscn")
var explosion_scene = preload("res://Scene/Explosion.tscn")

func _ready():
	position.z = PlayerData.GAME_DEPTH
	max_health = health

func _physics_process(_delta):
	velocity = Vector3(0, -1, 0) * speed
	if position.y <= -7:
		queue_free()
	move_and_slide()


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()


func die():
	PlayerData.add_score(max_health) # Add points equal to max_health on destruction

	# Create an explosion effect
	var explosion = explosion_scene.instantiate()
	get_tree().root.add_child(explosion)
	explosion.global_position = self.global_position

	queue_free() # Destroy the enemy


func shoot():
	var bullet = BulletPool.get_enemy_bullet()
	bullet.global_transform = self.global_transform
	bullet.global_position.y -= 1.0
	# Não precisa setar visible = true aqui, já é feito no pool


func _on_screen_exited():
	queue_free() # Also destroy the enemy if it goes off-screen


func _on_shoot_timer_timeout():
	shoot()
