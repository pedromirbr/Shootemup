extends Node3D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@onready var score_label = $UI/ScoreLabel
@onready var enemy_spawn_timer = $EnemySpawnTimer

func _ready():
	# Instantiate the player and connect its signal
	var player = player_scene.instantiate()
	player.died.connect(_on_player_died)
	add_child(player)

	# Start the timer to spawn enemies
	enemy_spawn_timer.start()


func _process(delta):
	# Update the score label
	score_label.text = "Score: %s" % PlayerData.score


func _on_enemy_spawn_timer_timeout():
	# Create an enemy instance
	var enemy = enemy_scene.instantiate()

	# Choose a random spawn position at the top of the screen
	var spawn_x = randf_range(-8.0, 8.0)
	var spawn_y = 6.0
	enemy.position = Vector3(spawn_x, spawn_y, 0)

	add_child(enemy)


func _on_player_died():
	# Stop spawning new enemies
	enemy_spawn_timer.stop()
	# Show the game over screen
	$UI/GameOverOverlay.visible = true


func _on_restart_button_pressed():
	# Reload the current scene to restart the game
	get_tree().reload_current_scene()
