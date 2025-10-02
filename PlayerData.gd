extends Node

var player_name: String = "Player"
var score: int = 0
var selected_ship: StringName = &"RedShip"

var ship_stats = {
	&"GreenShip": {
		"health": 100,
		"damage": 10,
		"speed_modifier": 1.2, # 20% faster
		"damage_reduction": 0.0
	},
	&"RedShip": {
		"health": 100,
		"damage": 12, # 20% more damage
		"speed_modifier": 1.0,
		"damage_reduction": 0.0
	},
	&"BlueShip": {
		"health": 100,
		"damage": 10,
		"speed_modifier": 1.0,
		"damage_reduction": 0.2 # Takes 20% less damage
	}
}

func get_current_ship_stats() -> Dictionary:
	if ship_stats.has(selected_ship):
		return ship_stats[selected_ship]
	# Return default stats if the selected ship is not found for some reason
	return ship_stats[&"RedShip"]

func add_score(amount: int):
	score += amount
	print("Score is now: ", score)

func reset():
	player_name = "Player"
	score = 0
	selected_ship = &"RedShip"
