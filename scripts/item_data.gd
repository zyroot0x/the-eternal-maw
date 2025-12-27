extends Resource
class_name ItemResource # Isso permite que ele apareça no menu da Godot!

@export var name: String = "Item"
@export var mass: float = 1.0
@export var sprite_texture: Texture2D
@export var pull_speed_mult: float = 1.0 # Para itens mais "pesados" serem lentos
@export var scale: Vector2 = Vector2(1.0, 1.0)
