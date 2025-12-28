extends Area2D

@export var item_info: ItemResource = null:
	set(value):
		item_info = value
		# Quando o recurso for colocado, ele já atualiza o Sprite automaticamente!
		if item_info and has_node("Sprite2D"):
			Sprite.texture = item_info.sprite_texture
			if is_node_ready():
				Sprite.scale = item_info.scale

@export_group("Nós usados")
@export var Player: AudioStreamPlayer2D = null
@export var Sprite: Sprite2D = null

var velocity: Vector2 = Vector2.ZERO
var being_pulled:bool = false
var is_dead: bool = false
var target = null


func _ready():
	rotation = randf() * TAU
	velocity = Vector2(20000, 0).rotated(randf() * TAU)

func _process(delta):
	# move em direção ao player se for válido
	if being_pulled and target:
		var direction = (target.global_position - global_position).normalized()
		direction =+ velocity * delta
		global_position += direction * delta
	
		var distance = global_position.distance_to(target.global_position)
		if distance < 10.0:
			be_consumed()

func start_pull(player_node):
	target = player_node
	being_pulled = true

func be_consumed():
	if is_dead:
		return
	is_dead = true
	
	if item_info:
		GameManager.add_mass(item_info.mass)
		visible = false
	
	if Player:
		Player.stream = item_info.collect_sound
		Player.play()
		await Player.finished
	
	queue_free()
