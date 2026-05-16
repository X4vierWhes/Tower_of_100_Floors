extends Node
class_name ItensControlComponent

@warning_ignore("unused_signal")signal itens_collected

func _drop_item(item: InteractableItem, throw_position: Vector2) -> void:
	add_child(item)
	item.price = 0
	item.top_level = true 
	#item.scale = Vector2(4, 4)
	item.global_position = throw_position
