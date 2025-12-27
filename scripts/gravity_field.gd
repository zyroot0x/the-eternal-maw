extends Area2D

@export_group("Configurações")
@export var growth_factor: float = 0.05

@export var Area: Area2D

func _ready():
	# Conecta o sinal do Singleton
	GameManager.mass_changed.connect(_on_mass_updated)
	
	# Conecta o sinal da sua Area2D de gravidade (GravityField)
	# No Inspector, conecte o sinal "area_entered" desta área ao script
	Area.area_entered.connect(_on_gravity_entered)

func _on_gravity_entered(area):
	if area.has_method("set"): # Verifica se é um item "puxável"
		area.target = self
		area.being_pulled = true

func _on_mass_updated(new_mass):
	var new_size = 1.0 + (sqrt(new_mass) * growth_factor)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(new_size, new_size), 0.3)
