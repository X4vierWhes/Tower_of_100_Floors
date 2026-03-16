extends Node
class_name RoomManager

@export var initial_room: int = 0
const DIR: String = "res://Scenes/rooms/room"

var actual_room: Room = null

func change_actual_room() -> void:
	pass

func get_room(room_id: int) -> void:
	if actual_room:
		actual_room.queue_free()
	
	
