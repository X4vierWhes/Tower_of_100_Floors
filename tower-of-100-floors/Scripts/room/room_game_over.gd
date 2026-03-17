extends Room
class_name GameOverRoom

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		get_tree().reload_current_scene()
