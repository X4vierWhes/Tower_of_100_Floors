extends Node2D
class_name Room

@export_category("Configurações")
@export var room_id: String = "null"
@export var next_room: String = "null"
@onready var itens_control: ItensControlComponent = $itens_control_component
@onready var enemies_list: Array

signal room_create

signal change_room

func _ready() -> void:
	if itens_control:
		Globals.item_component = itens_control

func _get_next_room() -> String:
	return next_room

func _drop_item(item: InteractableItem, throw_direction: Vector2) -> void:
	if !itens_control:
		return
	
	itens_control._drop_item(item, throw_direction)
