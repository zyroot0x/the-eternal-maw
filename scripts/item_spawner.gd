#Item Spawner
extends Node2D

@export var item_scene: PackedScene 
@export var possible_items: Array[ItemResource] = []
@export var spawn_radius: float = 600.0
@export var spawn_rate: float = 0.5

@onready var timer = $Timer

func _ready():
	timer.wait_time = spawn_rate
	timer.start()
	timer.timeout.connect(_on_timer_timeout)

# Surgimento dos itens
func spawn_item():
	if possible_items.is_empty() or item_scene == null:
		return
	
	var new_item = item_scene.instantiate()
	var random_data = possible_items.pick_random()
	
	new_item.item_data = random_data
	
	var angle = randf() * TAU
	var spawn_pos = Vector2(cos(angle), sin(angle)) * spawn_radius
	
	new_item.global_position = spawn_pos
	
	var direction_to_center = (global_position - new_item.global_position).normalized()
	var drift_direction = direction_to_center.rotated(randf_range(-1.0, 1.0))
	
	var speed = randf_range(20.0, 80.0)
	
	if is_item_special():
		speed *= 3.0
		new_item.modulate = Color.GOLD
	
	new_item.velocity = drift_direction * speed
	
	get_parent().call_deferred("add_child", new_item)


func _on_timer_timeout():
	if possible_items.is_empty() or item_scene == null:
		return
	
	spawn_item()


# decide se o item será rápido ou não
func is_item_special() -> bool:
	return randf() < 0.1
