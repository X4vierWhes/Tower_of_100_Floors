extends Node
class_name ItensControlComponent

signal itens_collected

func _drop_item(item: InteractableItem, throw_position: Vector2) -> void:
	add_child(item)
	
	item.top_level = true 
	#item.scale = Vector2(4, 4)
	item.global_position = throw_position
