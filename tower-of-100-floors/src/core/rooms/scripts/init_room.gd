extends Room
class_name InitRoom

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		emit_signal("change_room")
