extends Node3D

var selected_ship_node = null

func _ready():
	# Reset player data in case we are coming back to the menu
	PlayerData.reset()
	$UI/VBoxContainer/ConfirmButton.connect("pressed", _on_confirm_button_pressed)


func _on_confirm_button_pressed():
	if selected_ship_node == null:
		print("Please select a ship!")
		return

	var player_name_input = $UI/VBoxContainer/LineEdit.text
	if not player_name_input.is_empty():
		PlayerData.player_name = player_name_input

	PlayerData.selected_ship = selected_ship_node.name

	print("Player: %s, Ship: %s" % [PlayerData.player_name, PlayerData.selected_ship])
	get_tree().change_scene_to_file("res://Game.tscn")


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camera = $Camera3D
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var params = PhysicsRayQueryParameters3D.create(from, to)
		var result = space_state.intersect_ray(params)

		if result:
			var collider = result.collider
			if collider.is_in_group("ships"):
				if selected_ship_node:
					# Optional: Reset scale or visual indicator of the previously selected ship
					selected_ship_node.scale = Vector3(1, 1, 1)

				selected_ship_node = collider
				print("Selected: ", selected_ship_node.name)

				# Optional: Add a visual indicator for the newly selected ship
				selected_ship_node.scale = Vector3(1.2, 1.2, 1.2)
