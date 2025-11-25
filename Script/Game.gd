extends Node3D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene
@export var barrier_scene: PackedScene

@onready var score_label = $UI/ScoreLabel
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var river_generator = $RiverGenerator

func _ready():
	if river_generator:
		river_generator.barrier_scene = barrier_scene
	
	# Adicionar interface da IA
	var game_interface = preload("res://Script/GameInterface.gd").new()
	add_child(game_interface)
	
	var player = player_scene.instantiate()
	player.position = Vector3(0, 0, PlayerData.GAME_DEPTH)
	player.died.connect(_on_player_died)
	add_child(player)
	
	# Adicionar player ao grupo para fácil acesso
	player.add_to_group("player")
	
	enemy_spawn_timer.start()


func _process(_delta):
	# Update the score label
	score_label.text = "Score: %s" % PlayerData.score


func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()

	# ⭐ SPAWN DENTRO DO RIO
	var river_half_width = 3.0
	var spawn_x = randf_range(-river_half_width + 0.5, river_half_width - 0.5)  # Dentro do rio
	var spawn_y = 20.0  # Acima da tela
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
