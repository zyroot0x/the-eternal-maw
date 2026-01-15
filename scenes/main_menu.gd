extends CanvasLayer

@export var Level: PackedScene = null

@export_group("Nós usados")
@export var PlayButton: Button = null
@export var ExitButton: Button = null

func _ready() -> void:
	PlayButton.button_down.connect(_on_play_pressed)
	ExitButton.button_down.connect(_on_exit_pressed)

func _on_play_pressed():
	if Level:
		get_tree().change_scene_to_packed(Level)
	
	else:
		print("Erro: Esqueceu de arrastar a cena do jogo para o Inspector!")

func _on_exit_pressed():
	get_tree().quit()
