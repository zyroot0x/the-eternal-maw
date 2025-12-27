extends Area2D

@export var item_info: ItemResource:
	set(value):
		item_info = value
		# Quando o recurso for colocado, ele já atualiza o Sprite automaticamente!
		if item_info and has_node("Sprite2D"):
			$Sprite2D.texture = item_info.sprite_texture
			$Sprite2D.scale = item_info.scale

var being_pulled = false
var target = null
var pull_speed: float = 2.0

func _process(delta):
	if being_pulled and target:
		# Aumenta a velocidade gradualmente (aceleração gravitacional)
		pull_speed += delta * 10.0
		
		# Move em direção ao centro do player
		# Usamos global_position para evitar problemas com herança de transform
		global_position = global_position.move_toward(target.global_position, pull_speed)
		
		# Verifica se chegou no centro para ser "devorado"
		var distance = global_position.distance_to(target.global_position)
		if distance < 10.0:
			be_consumed()

func start_pull(player_node):
	target = player_node
	being_pulled = true

func be_consumed():
	if item_info:
		GameManager.add_mass(item_info.mass)
	queue_free() # Remove o item do jogo

func _ready():
	rotation = randf() * TAU
