extends Node

signal mass_changed(new_mass)

# sempre que o valor da massa muda, emite o sinal
var player_mass: float = 0.0:
	set(value):
		player_mass = value
		mass_changed.emit(player_mass)

func add_mass(amount: float) -> void:
	player_mass += amount

func player_mass_amount() -> String:
	var formated_mass = player_mass
	var prefixes: Array[String] = ["", "k", "M", "G", "T", "P", "E", "Z", "Y", "GRANDÃO"]
	var n = 0
	
	while formated_mass >= 1000:
		formated_mass /= 1000
		
	str(formated_mass)
	
	return "%.2f %s" % [formated_mass, prefixes[n]]

# Debug
var scroll: bool = false:
	set(value):
		scroll = value
		print(scroll)
