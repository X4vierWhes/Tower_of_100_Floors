extends InteractableItem
class_name PurchasableItem

@export var price: int = 10

func _interact() -> void:
	if price > player_pointer.coins:
		interact_label.text = "[shake][color=9ff4e5]Not enough money[/color][/shake]"
		return
	if is_player_in_area && player_pointer && consumable_item:
		player_pointer._equip(_get_item())
		player_pointer.coins -= price
		player_pointer.update_player.emit("use_item")
		if item_component && key_item:
			item_component.itens_collected.emit()
		queue_free()

func get_interact_label_text() -> String:
	if price > 0:
		return "[shake][color=9ff4e5]" + ITEM_NAME + " PRICE: " + str(price) + "[/color][/shake]"
	return "[shake][color=9ff4e5]" + INTERACT_TEXT + "[/color][/shake]"
