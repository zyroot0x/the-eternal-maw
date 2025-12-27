extends Node2D

# Arraste a cena base do seu item (Item.tscn) para cá
@export var item_scene: PackedScene 
# Arraste seus arquivos .tres (próton, pedra, etc.) para esta lista
@export var possible_items: Array[ItemResource] = []

@export var spawn_radius: float = 500.0 # Quão longe do centro eles surgem
@export var spawn_rate: float = 1.0     # Um item por segundo

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
	# 1. Escolhe um recurso aleatório da lista
	var random_data = possible_items.pick_random()
	
	# 2. Instancia a cena do Item
	var new_item = item_scene.instantiate()
	
	# 3. Define uma posição aleatória em um círculo
	var random_direction = Vector2.RIGHT.rotated(randf() * TAU)
	var spawn_pos = random_direction * spawn_radius
	
	# 4. Configura o item ANTES de adicionar à cena
	new_item.global_position = spawn_pos
	new_item.item_info = random_data
	
	# 5. Adiciona à árvore de nós (pode ser um nó "Items" no Level para organizar)
	get_node("../ItemContainer").add_child(new_item)
