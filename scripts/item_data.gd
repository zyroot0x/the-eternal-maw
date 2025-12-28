extends Resource
class_name ItemResource # Isso permite que ele apareça no menu da Godot!

@export var collect_sound: AudioStream = null
@export var sprite_texture: Texture2D = null
@export var mass: float = 1.0
@export var name: String = "Item"
