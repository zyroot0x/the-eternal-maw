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
@export var ScreenNotifier: VisibleOnScreenNotifier2D = null
@export var StreamPlayer: AudioStreamPlayer2D = null
@export var CpuParticles: CPUParticles2D = null
@export var Sprite: Sprite2D = null

# O próprio nó
@onready var me: Area2D = $"."

var velocity: Vector2 = Vector2.ZERO
var being_pulled: bool = false
var is_dead: bool = false
var target = null

func _ready():
	# Sorteio de ser rápido (50% de chance)
	var e_rapido = item_rapido() 
	
	# Define a velocidade base
	rotation = randf() * TAU
	var base_speed = 300.0
	
	# Se for rápido, adicionamos um "boost" aleatório
	if e_rapido:
		base_speed += randf_range(10.0, 100.0)
		
		# Muda a cor do sprite para dar a dica visual de que é especial
		Sprite.modulate = Color.GOLD 
	
	velocity = Vector2(base_speed, 0).rotated(rotation)
	
	ScreenNotifier.screen_exited.connect(_on_screen_exited)

func _process(delta):
	# O item sempre viaja pelo espaço (Deriva Espacial)
	global_position += velocity * delta
	
	if being_pulled and target:
		var distance = global_position.distance_to(target.global_position)
		var gravity_force = 100000.0 / (distance + 1.0) # O +1 evita divisão por zero
		var gravity_dir = (target.global_position - global_position).normalized()
		
		# A gravidade curva a trajetória da velocidade
		velocity += gravity_dir * gravity_force * delta
		
		# Verificação de consumo
		if distance < 360.0:
			be_consumed()

func start_pull(StreamPlayer_node):
	target = StreamPlayer_node
	being_pulled = true

# Quando o item é consumido pelo buraco negro
func be_consumed():
	if is_dead:
		return
	is_dead = true
	
	if item_info:
		GameManager.add_mass(item_info.mass)
		visible = false
	
	if StreamPlayer:
		StreamPlayer.stream = item_info.collect_sound
		StreamPlayer.play()
		CpuParticles.emitting = true
		CpuParticles.reparent(get_tree().root)
		await StreamPlayer.finished
	
	queue_free()

# Quando o item sai para fora da tela
func _on_screen_exited() -> void:
	if not being_pulled:
		queue_free()

# Decide se o item será rápido ou não
func item_rapido() -> bool:
	if randi_range(0, 1) == 1:
		return true
	else:
		return false
