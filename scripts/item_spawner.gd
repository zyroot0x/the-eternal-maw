extends Node2D

@export var item_scene: PackedScene 
@export var possible_items: Array[ItemResource] = []

@export var spawn_radius: float = 3000.0
@export var spawn_rate: float = 1.0

@onready var timer = $Timer

func _ready():
	timer.wait_time = spawn_rate
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if possible_items.is_empty() or item_scene == null:
		return
		
	spawn_item()

func spawn_item():
	# 1. escolhe um recurso aleatório da lista
	var random_data = possible_items.pick_random()
	
	# 2. instancia a cena do Item
	var new_item = item_scene.instantiate()
	
	# 3. define uma posição aleatória em um círculo
	var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
	var spawn_pos = random_direction * spawn_radius
	
	# 4. configura o item antes de adicionar à cena
	new_item.global_position = spawn_pos
	new_item.item_info = random_data
	
	# 5. adiciona à árvore de nós
	get_node("../ItemContainer").add_child(new_item)
