extends Node3D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@onready var score_label = $UI/ScoreLabel
@onready var enemy_spawn_timer = $EnemySpawnTimer

func _ready():
	# Se sua UI precisar de ajustes para modo retrato
	# $UI/ScoreLabel.position = Vector2(20, 20)  # Exemplo
	
	# Resto do código...
	var player = player_scene.instantiate()
	player.position = Vector3(0, 0, PlayerData.GAME_DEPTH)
	player.died.connect(_on_player_died)
	add_child(player)
	enemy_spawn_timer.start()


func _process(_delta):
	# Update the score label
	score_label.text = "Score: %s" % PlayerData.score


func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()

	var spawn_x = randf_range(PlayerData.PLAYER_BOUNDS_X.x, PlayerData.PLAYER_BOUNDS_X.y)
	var spawn_y = PlayerData.ENEMY_SPAWN_Y
	enemy.position = Vector3(spawn_x, spawn_y, PlayerData.GAME_DEPTH)

	add_child(enemy)


func _on_player_died():
	# Stop spawning new enemies
	enemy_spawn_timer.stop()
	# Show the game over screen
	$UI/GameOverOverlay.visible = true


func _on_restart_button_pressed():
	# Reload the current scene to restart the game
	get_tree().reload_current_scene()
