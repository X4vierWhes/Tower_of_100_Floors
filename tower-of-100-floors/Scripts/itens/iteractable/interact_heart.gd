extends InteractableItem
class_name InteractableHeart

func _interact() -> void: #Sobrescrever metodo
	if player_pointer && is_player_in_area:
		player_pointer._heal(player_pointer.max_health)
		if consumable_item:
			queue_free()
