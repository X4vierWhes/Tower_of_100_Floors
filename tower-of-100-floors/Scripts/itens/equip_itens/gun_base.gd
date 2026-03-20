extends Item
class_name GunBase

@export_category("Gun Base Parameters")
@export var damage: int = 10
@export var max_ammo: int = 22
@export var actual_clip: int = 22
@export var shoot_delay: float = 0.6
@onready var can_shoot: bool = true

const OBJ_BULLET = preload("uid://uy71c1b3cb13")

func shoot() -> void:
	pass

func reload() -> void:
	pass

func _get_texture() -> TextureRect:
	return null

func apply_upgrade() -> void:
	pass
