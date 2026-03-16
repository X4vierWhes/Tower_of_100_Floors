extends Node2D
class_name Room

@export_category("Configurações")
@export var room_id: String = "null"
@export var next_room: String = "null"
@onready var enemies_list: Array
signal change_room

func _get_next_room() -> String:
	return next_room
