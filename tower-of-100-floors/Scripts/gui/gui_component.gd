extends Node2D
class_name GUI

@export var itens_component: ItensComponent
@export var heart_component: HeartComponent
@export var gun_component: GunComponent

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var coins: Sprite2D = $CanvasLayer/itens_component/coins
@onready var bombs: Sprite2D = $CanvasLayer/itens_component/bombs

var player: Player = null

func _ready() -> void:
	if get_parent() is Player:
		player = get_parent()
		itens_component.set_itens(player.coins, player.bombs)
		heart_component.set_hearts(player.actual_health)
		player.update_player.connect(on_player_update)
		player.equipped_gun.connect(on_player_equipped_gun)

func on_player_update(action: String, action_count: int = 0) -> void:
	match action:
		"damage":
			_damage_player(action_count)
		"heal":
			_heal_player(action_count)
		"use_item":
			itens_component.set_itens(player.coins, player.bombs)

func _damage_player(damage_count: int) -> void:
	heart_component.update_actual_hearts("damage", damage_count)

func _heal_player(heal_count: int) -> void:
	heart_component.update_actual_hearts("heal", heal_count)

func on_player_equipped_gun(gun_to_equip: GunBase) -> void:
	#print("ON GUI COMPONENT PLAYER EQUIP GUN")
	gun_component.set_gun(gun_to_equip)
