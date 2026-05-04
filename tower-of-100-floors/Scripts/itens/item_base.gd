extends Node2D
class_name Item

@export_category("Configurações")
@export var drop_item_name: String = "null"
@export var item_name: String = "null"
@export_enum("Consumable", "Throwable") var item_type: String
@export var range_distance: float = 1200.0

var group_to_attack: String = "Enemies"
var travelled_distance: float = 0.0
var direction: Vector2 = Vector2.ZERO
var player_pointer: Player = null
var stats: ItemStats = null

const DIR_DROP_ITEM: String = "res://Scenes/itens/iteractable/"

func _ready() -> void:
	set_process(false)
	if stats:
		_update_item_actual_stats()
	

func _activate_item() -> void:
	match item_type:
		"Consumable":
			_apply_consumable_effect()
		"Throwable":
			set_process(true)

func _apply_consumable_effect() -> void:
	pass

func _get_drop_item() -> String:
	return DIR_DROP_ITEM + drop_item_name + ".tscn"

func _drop_item() -> InteractableItem:
	return null

func set_item_stats(new_stats: ItemStats) -> void:
	stats = new_stats
	if stats:
		_update_item_actual_stats()

func _update_item_actual_stats() -> void:
	pass
