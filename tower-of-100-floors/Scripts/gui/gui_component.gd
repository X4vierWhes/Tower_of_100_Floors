extends Node2D
class_name GUI

@export var itens_component: ItensComponent
@export var heart_component: HeartComponent
@export var gun_component: GunComponent

func gun_reload(gun: Pistol) -> void:
	if !gun:
		return
	var mod: int = gun.max_ammo - gun.actual_clip
	#print("MOD IN OBJPISTOL: " + str(mod))
	for i in range(mod):
		gun_component._stack()
		await get_tree().create_timer(.05).timeout
	gun.actual_clip = gun.max_ammo

func gun_shoot(gun: Pistol) -> void:
	if !gun:
		return
	if gun_component._unstack():
		gun.actual_clip -= 1

func player_take_damage(damage: int, player: Player) -> void:
	for i in range(damage):
		_heart_unstack(player)

func _heart_stack(player: Player) -> void:
	heart_component._stack()

func _heart_unstack(player: Player) -> void:
	heart_component._unstack()

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
