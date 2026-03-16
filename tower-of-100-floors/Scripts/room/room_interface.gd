extends TileMapLayer
class_name Room

@export_category("Configurações")
@export var room_id: int = 0
@onready var enemies_list: Array
signal change_room

func _ready() -> void:
	if get_parent() && get_parent() is RoomManager:
		pass

func _get_next_room() -> Room:
	return null
