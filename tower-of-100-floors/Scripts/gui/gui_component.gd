extends Node2D
class_name GUI

@export var itens_component: ItensComponent
@export var heart_component: HeartComponent
@export var gun_component: GunComponent

func update_player(player: Player) -> void:
	_update_heart(player.health)
	_update_itens(player.coins, player.bombs)

func update_gun(gun: Pistol) -> void:
	if gun_component:
		gun_component.update_ammo(gun._get_stats())
		gun_component._set_texture(gun._get_texture())

func _update_heart(_count) -> void:
	if heart_component:
		print("Entrei na update heart")
		heart_component._update_hearts(_count)

func _update_ammo(_count) -> void:
	if gun_component:
		print("Entrei na update ammo")
		gun_component.update_ammo(_count)

func _update_itens(_coins: int, _bombs: int) -> void:
	if itens_component:
		print("entrei na update itens")
		itens_component._update(_coins, _bombs)
