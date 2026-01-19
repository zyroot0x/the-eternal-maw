extends Camera2D

func _unhandled_input(event: InputEvent) -> void:
	# verifica se o zoom tá ativado
	if GameManager.scroll == true:
		pass
	
	else:
		return
	
	# aplica o zoom
	# ... (seu código de verificação do GameManager) ...

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(0.1, 0.1) # Afasta (número maior = área maior)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(0.1, 0.1) # Aproxima (número menor = área menor)

	# A trava de segurança crucial:
	zoom.x = clamp(zoom.x, 0.2, 3.0)
	zoom.y = clamp(zoom.y, 0.2, 3.0)
