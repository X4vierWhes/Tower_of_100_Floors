extends Item
class_name GunBase

var can_shoot: bool = true
var is_reloading: bool = false

@warning_ignore("unused_signal") signal update_gun(action_name: String)

func shoot(_force: float) -> void:
	push_error("NOT IMPLEMENTED")

func reload() -> void:
	push_error("NOT IMPLEMENTED")

func _apply_upgrade(_up: String) -> void:
	push_error("NOT IMPLEMENTED")

func _get_texture() -> Sprite2D:
	push_error("NOT IMPLEMENTED")
	return null

func apply_upgrade() -> void:
	push_error("NOT IMPLEMENTED")
	pass

func get_actual_clip() -> int:
	push_error("NOT IMPLEMENTED")
	return 0
