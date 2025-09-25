extends Node3D

var selected_ship = null
var player_name = ""

func _ready():
	# Connect the confirm button's pressed signal
	$UI/VBoxContainer/ConfirmButton.connect("pressed", self._on_confirm_button_pressed)

func _on_confirm_button_pressed():
	player_name = $UI/VBoxContainer/LineEdit.text
	if player_name.empty():
		player_name = $UI/VBoxContainer/LineEdit.placeholder_text

	# For now, we'll just print the selection.
	# Later, we'll need to handle ship selection logic.
	print("Player Name: ", player_name)
	print("Selected Ship: ", selected_ship)

	# Placeholder for starting the game
	# get_tree().change_scene_to_file("res://game.tscn")
pass

# We will add input handling for ship selection later.
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera = $Camera3D
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))

		if result:
			var collider = result.collider
			if collider.is_in_group("ships"):
				selected_ship = collider.name
				print("Selected: ", selected_ship)