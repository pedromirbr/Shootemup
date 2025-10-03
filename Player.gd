extends CharacterBody3D

signal died

@export var speed = 8.0
var bullet_scene = preload("res://PlayerBullet.tscn")

var health: int
var damage: int
var speed_modifier: float

func _ready():
	var stats = PlayerData.get_current_ship_stats()
	health = stats["health"]
	damage = stats["damage"]
	speed_modifier = stats["speed_modifier"]

	# Set the color based on the selected ship
	var ship_name = PlayerData.selected_ship
	var material = StandardMaterial3D.new()
	if ship_name == &"GreenShip":
		material.albedo_color = Color.GREEN
	elif ship_name == &"RedShip":
		material.albedo_color = Color.RED
	elif ship_name == &"BlueShip":
		material.albedo_color = Color.BLUE
	$Pivot/MeshInstance3D.set_surface_override_material(0, material)


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = Vector3(direction.x, -direction.y, 0) * speed * speed_modifier
	var target_roll = -direction.x * deg_to_rad(15)
	rotation.y = lerp_angle(rotation.y, target_roll, delta * speed)
	move_and_slide()

	# Clamp player position to stay within screen bounds (approximate)
	position.x = clamp(position.x, -8.5, 8.5)
	position.y = clamp(position.y, -4.5, 4.5)

	if Input.is_action_just_pressed("ui_accept"): # 'ui_accept' is usually Spacebar
		shoot()


func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.damage = self.damage
	# Add bullet to the main game scene, not as a child of the player
	get_tree().root.add_child(bullet)
	bullet.global_transform = self.global_transform
	bullet.global_position.y += 1.0 # Offset to shoot from the front


func take_damage(amount):
	var stats = PlayerData.get_current_ship_stats()
	var final_damage = amount * (1.0 - stats["damage_reduction"])
	health -= final_damage
	print("Player took %s damage, health is now %s" % [final_damage, health])
	if health <= 0:
		print("Player has been destroyed!")
		died.emit()
		queue_free()
