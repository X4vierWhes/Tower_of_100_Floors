extends Node2D
class_name Game

@export_category("Pivos")
@export var game_interface: GUI
@export var room_manager: Node

func _get_gui() -> GUI:
	return game_interface
