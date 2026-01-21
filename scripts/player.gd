#Player
extends Node2D

@export_group("Configurações")
@export var growth_factor: float = 0.05
@export var animation_duration: float = 0.3
@export var gravity_strenght: float = 100000.0

@export_group("Nós usados")
@export var AccretionDisk: Area2D = null
@export var EventHorizon: Area2D = null


func _ready():
	GameManager.mass_changed.connect(_on_mass_updated)
	EventHorizon.area_entered.connect(_on_event_horizon_entered)

func _physics_process(delta: float) -> void:
	rotate(0.001)
	_apply_gravity(delta)

func _apply_gravity(delta: float) -> void:
	var items_in_range = AccretionDisk.get_overlapping_areas()
	
	for area in items_in_range:
		if area.is_in_group("Item") and area.has_method("apply_pull_force"):
			area.apply_pull_force(global_position, gravity_strenght, delta)

func _on_event_horizon_entered(area: Area2D) -> void:
	if area.is_in_group("Item") and "mass" in area:
		print("Área entrou: ", area)
		attempt_eat(area)

func attempt_eat(item_area: Area2D) -> void:
	if GameManager.player_mass >= item_area.mass:
		GameManager.add_mass(item_area.mass)
		
		item_area.AudioPlayer.play()
		
		item_area.die()
	
	else:
		# mais tarde implementar lógida de dano/ repulsão
		print("Erro: o item é maior que o buraco negro!")	

# sempre que o buraco engole algo
func _on_mass_updated(new_mass: float):
	if new_mass <= 0:
		return
	
	var magnitude = log(new_mass) / log(10)
	var new_size = 1.0 + (magnitude * growth_factor)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(new_size, new_size), animation_duration)
