extends Node2D
class_name Item

@export_category("Configurações")
@export var drop_item_name: String = "null"

var gui_pointer: GUI = null
var player_pointer: Player = null
const DIR_DROP_ITEM: String = "res://Scenes/itens/iteractable_itens/"
var stats: ItemStats = null

func _ready() -> void:
	set_process(false)

func _set_pointers(player: Player, gui: GUI) -> void:
	player_pointer = player as Player
	gui_pointer = gui as GUI

func _get_drop_item() -> String:
	return DIR_DROP_ITEM + drop_item_name + ".tscn"

func _drop_item(_throw_direction: Vector2) -> InteractableItem:
	return null

func set_item_stats(new_stats: ItemStats) -> void:
	stats = new_stats
	if stats:
		_update_item_actual_stats(stats)

func _update_item_actual_stats(stats: ItemStats) -> void:
	pass
