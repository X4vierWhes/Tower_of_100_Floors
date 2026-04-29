extends Node2D
class_name Room

@export_category("Configurações")
@export var room_id: String = "null"
@export var next_room: String = "null"
@export var room_principal_layer: TileMapLayer
@export var itens_control: ItensControlComponent
@export var doors_and_plates: DoorAndPlatesComponent
@export var enemies_control: EnemiesControl


@warning_ignore("unused_signal") signal change_room

func _ready() -> void:
	if itens_control:
		Globals.item_component = itens_control
	
	Globals.actual_room_id = room_id

func _get_next_room() -> String:
	if next_room == "null":
		var nr: String = str(int(room_id) + 1)
		next_room = nr
	return next_room

func _drop_item(item: InteractableItem, throw_direction: Vector2) -> void:
	if !itens_control:
		return
	
	itens_control._drop_item(item, throw_direction)
