extends Node
class_name RoomManager

@export var initial_room: String = "0"
@export var game: Game
@export var transition: TransitionComponent
@export var gui: GUI
const DIR: String = "res://Scenes/rooms/room"

var actual_room: Room = null

func init_game() -> void:
	change_without_transition(initial_room)

func change_actual_room() -> void:
	change_room(get_next_room(actual_room))

func change_without_transition(room_to_open: String) -> void:
	gui.change_visibilty()
	if room_to_open == "null":
		return
	if actual_room:
		actual_room.queue_free()
	
	var room = load(DIR + room_to_open + ".tscn")
	if room:
		actual_room = room.instantiate() as Room
		add_child(actual_room)
		actual_room.change_room.connect(change_actual_room)
	
	gui.change_visibilty()

func change_room(room_to_open: String) -> void:
	gui.change_visibilty()
	if room_to_open == "null":
		return
	transition.fade_in(.5)
	await transition.on_transition_end
	if actual_room:
		actual_room.queue_free()
	
	var room = load(DIR + room_to_open + ".tscn")
	if room:
		actual_room = room.instantiate() as Room
		game._spawn_player()
		await get_tree().create_timer(0.3).timeout
		add_child(actual_room)
		actual_room.change_room.connect(change_actual_room)
	
	gui.change_visibilty()
	transition.fade_out(.5)

func get_next_room(actual: Room) -> String:
	return actual._get_next_room()
