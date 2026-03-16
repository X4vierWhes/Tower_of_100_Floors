extends IteractableItem
class_name EasterEgg


@onready var richText: RichTextLabel = _get_interact_label_text(self)

func _ready() -> void:
	if get_parent() && get_parent() is ItensControlComponent:
		item_component = get_parent()
	top_level = true
	richText.hide()
	add_child(richText)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		richText.show()
		is_player_in_area = true
		player_pointer = body as Player


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		richText.hide()
		is_player_in_area = false
