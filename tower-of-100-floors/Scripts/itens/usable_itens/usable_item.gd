extends Node2D
class_name UsableItem

@export_category("Configurações")
@export var item_name: String = "null"
@export var throwable: bool = false
@export var consumable: bool = false
@export var range_distance: float = 1200.0

var travelled_distance: float = 0.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	set_process(false)

func _apply_consumable_effect() -> void:
	pass

func _activate_item() -> void:
	set_process(true)
