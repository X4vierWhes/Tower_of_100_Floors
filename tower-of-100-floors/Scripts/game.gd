extends Node2D
class_name Game

@export_category("Pivos")
@export var room_manager: RoomManager
@export var player_loader: PlayerLoader
@export var transition_component: TransitionComponent

@onready var player_spawn: Marker2D = $player_spawn

const PLAYER_SCENE: String = "uid://ckisamdxmuhow"
var player_in_scene: Player = null

func _ready() -> void:
	room_manager.init_game()

func _get_player_stats() -> void:
	pass

func _spawn_player() -> void:
	if !player_in_scene:
		var player_scene_resource = load(PLAYER_SCENE) as PackedScene
		var player_instance = player_scene_resource.instantiate() as Player
		
		if player_instance:
			player_in_scene = player_instance
			add_child(player_in_scene)
			_set_player_location()
			
			if not player_in_scene.is_death.is_connected(_player_is_death):
				player_in_scene.is_death.connect(_player_is_death)
	else:
		_set_player_location()

func _set_player_location() -> void:
	player_in_scene.global_position = player_spawn.global_position

func _player_is_death() -> void:
	room_manager.change_room("_game_over")
