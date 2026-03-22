extends Node2D
class_name GUI

@export var itens_component: ItensComponent
@export var heart_component: HeartComponent
@export var gun_component: GunComponent

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var coins: Sprite2D = $CanvasLayer/itens_component/coins
@onready var bombs: Sprite2D = $CanvasLayer/itens_component/bombs

func change_visibilty() -> void:
	canvas_layer.visible = !canvas_layer.visible
	coins.visible = !coins.visible
	bombs.visible = !bombs.visible

func gun_reload(gun: GunBase) -> void:
	if !gun:
		return
	var mod: int = gun.max_ammo - gun.actual_clip
	#print("MOD IN OBJPISTOL: " + str(mod))
	for i in range(mod):
		gun_component._stack()
		await get_tree().create_timer(.05).timeout
	gun.actual_clip = gun.max_ammo

func gun_shoot(gun: GunBase) -> void:
	if !gun:
		return
	if gun_component._unstack():
		gun.actual_clip -= 1

func gun_drop() -> void:
	return

func player_take_damage(damage: int) -> void:
	for i in range(damage):
		_heart_unstack()
	

func player_heal(heal: int) -> void:
	for i in range(heal):
		_heart_stack()

func _heart_stack() -> void:
	heart_component._stack()

func _heart_unstack() -> void:
	heart_component._unstack()

func update_player(player: Player) -> void:
	_update_heart(player.actual_health)
	_update_itens(player.coins, player.bombs)

func update_gun(gun: GunBase) -> void:
	if gun_component:
		gun_component.update_ammo(gun._get_stats())
		gun_component._set_texture(gun._get_texture())

func _update_heart(_count) -> void:
	if heart_component:
		heart_component._update_hearts(_count)

func _update_ammo(_count) -> void:
	if gun_component:
		gun_component.update_ammo(_count)

func _update_itens(_coins: int, _bombs: int) -> void:
	if itens_component:
		itens_component._update(_coins, _bombs)
