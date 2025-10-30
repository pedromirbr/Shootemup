extends CharacterBody3D

signal died

@export var speed = 12.0
var bullet_scene = preload("res://Scene/PlayerBullet.tscn")

var health: int
var damage: int
var speed_modifier: float

var is_invulnerable: bool = false
var invulnerability_time: float = 0.5

func _ready():
	position.z = PlayerData.GAME_DEPTH
	var stats = PlayerData.get_current_ship_stats()
	health = stats["health"]
	damage = stats["damage"]
	speed_modifier = stats["speed_modifier"]

	# CORREÇÃO: Usar cores básicas por enquanto (depois criamos os materiais)
	var ship_name = PlayerData.selected_ship
	var material = StandardMaterial3D.new()
	
	match ship_name:
		&"GreenShip":
			material.albedo_color = Color.GREEN
		&"RedShip":
			material.albedo_color = Color.RED
		&"BlueShip":
			material.albedo_color = Color.BLUE
	
	$Pivot/MeshInstance3D.set_surface_override_material(0, material)


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(direction.x, -direction.y, 0) * speed * speed_modifier
	var target_roll = -direction.x * deg_to_rad(15)
	rotation.y = lerp_angle(rotation.y, target_roll, delta * speed)
	move_and_slide()

	# ATUALIZADO: Clamp para resolução 800x1024 (modo retrato)
	position.x = clamp(position.x, PlayerData.PLAYER_BOUNDS_X.x, PlayerData.PLAYER_BOUNDS_X.y)
	position.y = clamp(position.y, PlayerData.PLAYER_BOUNDS_Y.x, PlayerData.PLAYER_BOUNDS_Y.y)
	position.z = PlayerData.GAME_DEPTH  # Manter profundidade

	print("Posição: ", position)

	if Input.is_action_just_pressed("ui_accept"):
		shoot()


func shoot():
	var bullet = BulletPool.get_player_bullet()
	bullet.damage = self.damage
	bullet.global_transform = self.global_transform
	bullet.global_position.y += 1.0
	# Não precisa setar visible = true aqui, já é feito no pool

func take_damage(amount):
	if is_invulnerable:
		return
		
	var stats = PlayerData.get_current_ship_stats()
	var final_damage = amount * (1.0 - stats["damage_reduction"])
	health -= final_damage
	
	# FEEDBACK VISUAL: Piscar nave
	start_flash_effect()
	
	print("Player took %s damage, health is now %s" % [final_damage, health])
	if health <= 0:
		print("Player has been destroyed!")
		died.emit()
		queue_free()

func start_flash_effect():
	is_invulnerable = true
	var mesh = $Pivot/MeshInstance3D
	
	# Piscar a nave de forma simples
	var tween = create_tween()
	for i in range(4):  # 4 piscadas
		tween.tween_callback(func(): mesh.visible = false).set_delay(0.1)
		tween.tween_callback(func(): mesh.visible = true).set_delay(0.1)
	
	# Restaurar após invulnerabilidade
	await get_tree().create_timer(invulnerability_time).timeout
	is_invulnerable = false
	mesh.visible = true
