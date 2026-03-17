extends Node2D
class_name Game

@export_category("Pivos")
@export var game_interface: GUI
@export var room_manager: RoomManager
@export var player_loader: PlayerLoader

@onready var player_spawn: Marker2D = $player_spawn

const PLAYER_SCENE: String = "uid://ckisamdxmuhow"
var player_in_scene: Player = null

func _ready() -> void:
	room_manager.init_game()

func _get_gui() -> GUI:
	return game_interface

func _get_player_stats() -> void:
	pass

func _spawn_player() -> void:
	if !player_in_scene:
		var player = load(PLAYER_SCENE)
		player = player.instantiate() as Player
		if player:
			player_in_scene = player
			add_child(player_in_scene)
			_set_player_location()
	else: #Player ja criado
		_set_player_location()

func _set_player_location() -> void:
	player_in_scene.global_position = player_spawn.global_position
