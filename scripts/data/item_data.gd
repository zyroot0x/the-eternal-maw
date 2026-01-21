extends Resource
class_name ItemResource

@export var name: String = "Item"
@export var sprite_texture: Texture2D = null

@export_group("Física do Jogo")
@export var mass: float = 1.0

@export_group("Visual e Colisão")
@export var collision_radius: float = 30.0
@export var visual_scale: float = 1.0
