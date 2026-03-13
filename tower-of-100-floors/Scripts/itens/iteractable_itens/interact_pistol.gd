extends IteractableItem
class_name InteractPistol

@onready var label: RichTextLabel = _get_interact_label_text()
@onready var label_location: Marker2D = $label_location

func _ready() -> void:
	label_location.add_child(label)
	label.global_position = label_location.global_position
	label.global_position.x -= 40.0
	label.custom_minimum_size = Vector2(200, 50)
	label.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Corpo entrou")
	if body.is_in_group("Player"):
		label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("Corpo saiu")
	if body.is_in_group("Player"):
		label.hide()
