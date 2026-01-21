#Game Manager
extends Node

signal mass_changed(new_mass)

# sempre que o valor da massa muda, emite o sinal
var player_mass: float = 0.0:
	set(value):
		player_mass = value
		mass_changed.emit(player_mass)

func add_mass(amount: float) -> void:
	player_mass += amount

func get_formatted_mass() -> String:
	var temp_mass = player_mass
	var prefixes: Array[String] = ["g", "kg", "Mg", "Gg", "Tg", "Pg", "Eg", "Zg", "Yg", "GRANDÃO"]
	var n = 0
	
	while temp_mass >= 1000.0 and n < prefixes.size() - 1:
		temp_mass /= 1000.0
		n += 1
	
	return "%.2f %s" % [temp_mass, prefixes[n]]

# Debug
var scroll: bool = false
