extends Node2D

# Configurações exportadas facilitam o ajuste fino no Inspector
@export_group("Configurações de Crescimento")
@export var base_scale: float = 1.0
@export var growth_factor: float = 0.02
@export var animation_duration: float = 0.3

var current_mass: float = 0.0

func _ready():
	# Conectamos o sinal do GameManager para reagir quando a massa subir
	GameManager.mass_changed.connect(_on_mass_updated)
	scale = Vector2(base_scale, base_scale)

func _on_mass_updated(new_total_mass: float):
	current_mass = new_total_mass
	_update_visual_scale()

func _update_visual_scale():
	# Calculamos o novo tamanho baseado na massa total
	# Usamos sqrt (raiz quadrada) para que o crescimento não seja linearmente infinito
	var new_size = base_scale + (sqrt(current_mass) * growth_factor)
	
	# Criamos um Tween para o crescimento ser suave e orgânico
	var tween = create_tween()
	# TRANS_ELASTIC ou TRANS_BACK dão aquele efeito viciante de "quicar"
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(new_size, new_size), animation_duration)

func _on_gravity_field_area_entered(area: Area2D) -> void:
	# Verificamos se o que entrou na área é um item "comível"
	if area.has_method("start_pull"): 
		area.start_pull(self) # Passamos o próprio Player como alvo

	print("Algo entrou no campo: ", area.name) # Isso deve aparecer no Output
	if area.has_method("start_pull"):
		print("É um item válido! Puxando...")
		area.start_pull(self)
