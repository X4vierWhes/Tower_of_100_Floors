extends IteractableItem
class_name InteractablePistol

@onready var richText: RichTextLabel = _get_interact_label_text(self)

func _ready() -> void:
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
