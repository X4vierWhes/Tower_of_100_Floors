extends Node2D
class_name UsableItem

@export_category("Configurações")
@export var item_name: String = "null"
@export_enum("CONSUMABLE", "THROWABLE") var item_type: String = "THROWABLE"
@export var range_distance: float = 1200.0

var travelled_distance: float = 0.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_process(false)

func _activate_item() -> void:
	match item_type:
		"CONSUMABLE":
			_apply_consumable_effect()
		"THROWABLE":
			set_process(true)

func _apply_consumable_effect() -> void:
	pass
