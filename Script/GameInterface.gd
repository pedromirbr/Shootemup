extends Node

# Comunicação com IA Python usando UDPServer
var udp_server = UDPServer.new()
var peers = []  # Array para armazenar conexões
var python_port = 9090  # Porta que o Python conecta

# Estado do jogo
var current_state = {}
var last_score = 0
var last_health = 100

func _ready():
	# Iniciar servidor UDP
	var result = udp_server.listen(python_port)
	if result == OK:
		print("GameInterface: UDP Server listening on port ", python_port)
	else:
		push_error("GameInterface: Failed to listen on port " + str(python_port))
	
	# Timer para comunicação constante
	var timer = Timer.new()
	timer.wait_time = 0.033  # ~30 FPS para a IA
	timer.autostart = true
	timer.timeout.connect(_process_communication)
	add_child(timer)

func _process_communication():
	# Processar pacotes recebidos
	udp_server.poll()
	
	# Verificar novas conexões
	while udp_server.is_connection_available():
		var peer = udp_server.take_connection()
		peers.append(peer)
		print("GameInterface: New Python client connected")
	
	# Processar pacotes de todos os peers
	for peer in peers:
		if peer.get_available_packet_count() > 0:
			var packet = peer.get_packet()
			if packet.size() > 0:
				process_received_packet(packet, peer)
	
	# Enviar estado do jogo para todos os peers conectados
	if peers.size() > 0:
		send_state_to_python()

func process_received_packet(packet: PackedByteArray, peer: PacketPeer):
	var json_string = packet.get_string_from_utf8()
	var json_parser = JSON.new()
	
	var error = json_parser.parse(json_string)
	if error == OK:
		var action_data = json_parser.data
		execute_action(action_data)
	else:
		print("GameInterface: JSON parse error: ", json_string)

func send_state_to_python():
	var state = get_game_state()
	var json_state = JSON.stringify(state)
	var packet_data = json_state.to_utf8_buffer()
	
	# Enviar para todos os peers conectados
	for peer in peers:
		peer.put_packet(packet_data)

func get_game_state():
	var player = get_tree().get_first_node_in_group("player")
	if not player or not is_instance_valid(player):
		return {"done": true}
	
	# Coletar estado completo do jogo
	var state = {
		"player_x": player.position.x,
		"player_y": player.position.y,
		"player_health": player.health,
		"enemy_positions": get_enemy_positions(),
		"bullet_positions": get_bullet_positions(),
		"player_bullets": get_player_bullet_positions(),
		"score": PlayerData.score,
		"reward": calculate_reward(),
		"done": false
	}
	
	last_score = PlayerData.score
	last_health = player.health
	
	return state

func get_enemy_positions():
	var enemy_positions = []
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy_positions.append({
				"x": enemy.position.x,
				"y": enemy.position.y,
				"type": "enemy",
				"health": enemy.get("health") or 1
			})
	
	return enemy_positions

func get_bullet_positions():
	var bullet_positions = []
	var enemy_bullets = get_tree().get_nodes_in_group("enemy_bullets")
	
	for bullet in enemy_bullets:
		if is_instance_valid(bullet) and bullet.visible:
			bullet_positions.append({
				"x": bullet.position.x,
				"y": bullet.position.y,
				"type": "enemy_bullet"
			})
	
	return bullet_positions

func get_player_bullet_positions():
	var player_bullets = []
	var bullets = get_tree().get_nodes_in_group("player_bullets")
	
	for bullet in bullets:
		if is_instance_valid(bullet) and bullet.visible:
			player_bullets.append({
				"x": bullet.position.x,
				"y": bullet.position.y,
				"type": "player_bullet"
			})
	
	return player_bullets

func calculate_reward():
	var player = get_tree().get_first_node_in_group("player")
	if not player or not is_instance_valid(player):
		return -10
	
	var reward = 0.0
	
	# Recompensa por sobreviver
	reward += 0.1
	
	# Recompensa por aumentar score
	if PlayerData.score > last_score:
		reward += (PlayerData.score - last_score) * 2
	
	# Punição por perder vida
	if player.health < last_health:
		reward -= (last_health - player.health) * 5
	
	return reward

func execute_action(action):
	var player = get_tree().get_first_node_in_group("player")
	if not player or not is_instance_valid(player):
		return
	
	# Reset velocity para controle preciso
	player.velocity = Vector3.ZERO
	
	# Mapear ações numéricas para controles
	match action:
		0:  # Mover esquerda
			player.velocity.x = -player.speed * player.speed_modifier
		1:  # Mover direita
			player.velocity.x = player.speed * player.speed_modifier
		2:  # Mover cima
			player.velocity.y = player.speed * player.speed_modifier
		3:  # Mover baixo
			player.velocity.y = -player.speed * player.speed_modifier
		4:  # Atirar
			player.shoot()

func _exit_tree():
	# Fechar servidor ao sair
	udp_server.stop()
	for peer in peers:
		peer.close()
	print("GameInterface: UDP Server stopped")
