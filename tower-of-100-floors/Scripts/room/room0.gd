extends Room
class_name TutorialRoom

@onready var door_and_plates_component: DoorAndPlatesComponent = $door_and_plates_component

func open_door() -> void:
	door_and_plates_component.apply_next_room()

func _on_itens_control_component_itens_collected() -> void:
	open_door()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("change_room")


func _on_enemies_control_component_enemies_empty() -> void:
	open_door()
