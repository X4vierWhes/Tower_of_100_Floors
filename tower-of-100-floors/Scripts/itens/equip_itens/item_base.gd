extends CharacterBody2D
class_name Item

@export_category("Configurações")
@export var item_name: String = "null"
@export var damage: int = 2
@export var max_ammo: int = 22
@export var actual_clip: int = 22
@onready var gui_pointer: GUI = null
@onready var player_pointer: Player = null
const DIR_DROP_ITEM: String = "res://Scenes/itens/iteractable_itens/"

func _set_pointers(player: Player, gui: GUI) -> void:
	player_pointer = player as Player
	gui_pointer = gui as GUI

func _get_drop_item() -> IteractableItem:
	return null
