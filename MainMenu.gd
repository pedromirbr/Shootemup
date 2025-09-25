extends Control

func _on_start_button_pressed():
	print("Start button pressed")
	# get_tree().change_scene_to_file("res://game.tscn") # This will be used later


func _on_quit_button_pressed():
	get_tree().quit()