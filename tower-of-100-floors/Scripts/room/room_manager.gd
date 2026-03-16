extends Node
class_name RoomManager

@export var initial_room: String = "0"
@export var game: Game
const DIR: String = "res://Scenes/rooms/room"

var actual_room: Room = null

func init_game() -> void:
	change_room(initial_room)

func change_actual_room() -> void:
	print("Mudei de sala")

func change_room(room_to_open: String) -> void:
	if actual_room:
		actual_room.queue_free()
	
	var room = load(DIR + room_to_open + ".tscn")
	if room:
		actual_room = room.instantiate() as Room
		add_child(actual_room)
		actual_room.change_room.connect(change_actual_room)
		game._spawn_player()

func get_next_room(actual: Room) -> String:
	return actual._get_next_room()
