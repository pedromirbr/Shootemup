extends StaticBody3D

@export var barrier_height: float = 1.0  # ⭐ MAIS BAIXO
@export var barrier_color: Color = Color.DARK_GREEN

func _ready():
	# Configurar a aparência da barreira
	var mesh = $MeshInstance3D
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(0.3, barrier_height, 0.3)  # ⭐ MAIS FINO
	mesh.mesh = cube_mesh
	
	# Configurar o material
	var material = StandardMaterial3D.new()
	material.albedo_color = barrier_color
	mesh.material_override = material
	
	# Configurar a colisão
	var collision = $CollisionShape3D
	var shape = BoxShape3D.new()
	shape.size = Vector3(0.3, barrier_height, 0.3)
	collision.shape = shape
