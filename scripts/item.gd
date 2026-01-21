#Item
extends Area2D

@export var item_data: ItemResource = null

@export_group("Nós usados")
@export var ScreenNotifier: VisibleOnScreenNotifier2D = null
@export var AudioPlayer: AudioStreamPlayer2D = null
@export var CollisionShape: CollisionShape2D = null
@export var CpuParticles: CPUParticles2D = null
@export var Sprite: Sprite2D = null

var velocity: Vector2 = Vector2.ZERO
var mass: float = 1.0
var is_dying: bool = false

func _ready():
	add_to_group("Item")
	
	if item_data: 
		mass = item_data.mass
		CollisionShape.shape.radius = item_data.collision_radius
		Sprite.texture = item_data.sprite_texture
		
		var visual_scale = clamp(log(mass) * 0.1, 0.5, 3.0) 
		scale = Vector2(visual_scale, visual_scale)

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
	global_position += velocity * delta

func apply_pull_force(center_position: Vector2, strength: float, delta: float):
	var direction = (center_position - global_position).normalized()
	var distance = global_position.distance_to(center_position)
	
	var forca_magnitude = strength / (distance + 10.0)
	
	velocity += direction * forca_magnitude * delta

func die():
	if is_dying:
		return
	is_dying = true
	
	Sprite.visible = false
	CollisionShape.set_deferred("disabled", true)
	
	if item_data and item_data.collect_sound:
		AudioPlayer.stream = item_data.collect_sound
		AudioPlayer.play()
	
	if CpuParticles:
		var particles_clone = CpuParticles.duplicate()
		get_tree().root.add_child(particles_clone)
		particles_clone.global_position = global_position
		particles_clone.emitting = true
		
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_callback(particles_clone.queue_free)
	
	if AudioPlayer.stream:
		await AudioPlayer.finished
	
	queue_free()

# quando o item sai para fora da tela
func _on_screen_exited() -> void:
	if not is_dying:
		queue_free()
