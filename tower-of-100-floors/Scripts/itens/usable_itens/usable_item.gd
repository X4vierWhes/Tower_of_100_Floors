extends Node2D
class_name UsableItem

@export_category("Configurações")
@export var item_name: String = "null"
@export var throwable: bool = false
@export var consumable: bool = false
@export var throw_count: int = 1

func _ready() -> void:
	set_process(false)

func _apply_consumable_effect() -> void:
	pass

func _throw_item(t_count: int = 1) -> void:
	throw_count = t_count
	set_process(true)
