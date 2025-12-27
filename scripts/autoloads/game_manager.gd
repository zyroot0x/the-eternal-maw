extends Node

signal mass_changed(new_mass)

var total_mass: float = 0.0:
	set(value):
		total_mass = value
		mass_changed.emit(total_mass) # Avisa todo mundo que a massa mudou

func add_mass(amount: float) -> void:
	total_mass += amount
