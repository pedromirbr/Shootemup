extends Camera3D

func _ready():
	# Forçar esta câmera a ser a atual
	make_current()
	
	# Configurar posição e propriedades
	position = Vector3(0, 0, 50)
	size = PlayerData.camera_size
