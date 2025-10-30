extends Node

# Singleton instance
static var instance: BulletPool

var player_bullet_pool: Array = []
var enemy_bullet_pool: Array = []
var pool_size: int = 20

var player_bullet_scene = preload("res://Scene/PlayerBullet.tscn")
var enemy_bullet_scene = preload("res://Scene/EnemyBullet.tscn")

func _ready():
	instance = self
	initialize_pools()

func initialize_pools():
	# Pré-instanciar balas
	for i in pool_size:
		var player_bullet = player_bullet_scene.instantiate()
		var enemy_bullet = enemy_bullet_scene.instantiate()
		
		player_bullet.visible = false
		enemy_bullet.visible = false
		
		player_bullet_pool.append(player_bullet)
		enemy_bullet_pool.append(enemy_bullet)
		
		get_tree().root.add_child(player_bullet)
		get_tree().root.add_child(enemy_bullet)

# Métodos estáticos para acesso fácil
static func get_player_bullet() -> Node:
	return instance._get_player_bullet()

static func get_enemy_bullet() -> Node:
	return instance._get_enemy_bullet()

static func return_player_bullet(bullet: Node):
	instance._return_player_bullet(bullet)

static func return_enemy_bullet(bullet: Node):
	instance._return_enemy_bullet(bullet)

# Implementações internas
func _get_player_bullet() -> Node:
	if player_bullet_pool.size() > 0:
		var bullet = player_bullet_pool.pop_back()
		bullet.visible = true
		return bullet
	else:
		var bullet = player_bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		return bullet

func _get_enemy_bullet() -> Node:
	if enemy_bullet_pool.size() > 0:
		var bullet = enemy_bullet_pool.pop_back()
		bullet.visible = true
		return bullet
	else:
		var bullet = enemy_bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		return bullet

func _return_player_bullet(bullet: Node):
	bullet.visible = false
	bullet.position = Vector3.ZERO
	player_bullet_pool.append(bullet)

func _return_enemy_bullet(bullet: Node):
	bullet.visible = false
	bullet.position = Vector3.ZERO
	enemy_bullet_pool.append(bullet)
