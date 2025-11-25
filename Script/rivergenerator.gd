extends Node3D

@export var barrier_scene: PackedScene
# ⭐ REMOVER variáveis locais, usar constantes globais
@export var segment_length: float = 2.0
@export var segments_ahead: int = 20

var current_segment: int = 0
var barriers: Array = []
var largura: float =20.0
var probability_of_one: float = 0

func _ready():
	generate_initial_segments()

func _physics_process(delta):
	# ⭐ USAR CONSTANTE GLOBAL para velocidade
	for barrier in barriers:
		barrier.position.y -= PlayerData.RIVER_SCROLL_SPEED * delta
	
	clean_off_screen_barriers()

func generate_initial_segments():
	for i in range(segments_ahead):
		create_segment(i * segment_length)

func create_segment(y_position: float):
	# ⭐ USAR CONSTANTES GLOBAIS para posições
	
	if largura/5 > randf():
		largura=largura-1
	else:
		largura=largura+1	
	
	var left_barrier = barrier_scene.instantiate()
	left_barrier.position = Vector3(PlayerData.RIVER_BARRIER_LEFT_POS+largura, y_position, PlayerData.GAME_DEPTH)
	add_child(left_barrier)
	barriers.append(left_barrier)
	
	var right_barrier = barrier_scene.instantiate()
	right_barrier.position = Vector3(PlayerData.RIVER_BARRIER_RIGHT_POS-largura, y_position, PlayerData.GAME_DEPTH)
	add_child(right_barrier)
	barriers.append(right_barrier)

func clean_off_screen_barriers():
	var barriers_to_remove = []
	
	for barrier in barriers:
		if barrier.position.y < -20.0:
			barriers_to_remove.append(barrier)
	
	for barrier in barriers_to_remove:
		barriers.erase(barrier)
		barrier.queue_free()
	
	generate_new_barriers()

func generate_new_barriers():
	if barriers.size() == 0:
		return
	
	var highest_barrier = barriers[0]
	for barrier in barriers:
		if barrier.position.y > highest_barrier.position.y:
			highest_barrier = barrier
	
	if highest_barrier.position.y < segment_length * (segments_ahead - 2):
		create_segment(highest_barrier.position.y + segment_length)
