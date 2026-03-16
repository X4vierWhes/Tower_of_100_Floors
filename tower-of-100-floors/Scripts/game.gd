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
	var player = load(PLAYER_SCENE)
	if player:
		print("Peguei player")
