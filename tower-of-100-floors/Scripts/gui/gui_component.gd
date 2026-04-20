extends Node2D
class_name GUI

@export var itens_component: ItensComponent
@export var heart_component: HeartComponent
@export var gun_component: GunComponent

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var coins: Sprite2D = $CanvasLayer/itens_component/coins
@onready var bombs: Sprite2D = $CanvasLayer/itens_component/bombs

var player: Player = null
var equipped_gun: GunBase = null
var can_update: bool = true

func _ready() -> void:
	if get_parent() is Player:
		player = get_parent()
		player.equipped_gun.connect(_equip_gun)
		equipped_gun = player._get_gun()

func _process(_delta: float) -> void:
	update()

func update() -> void:
	if !can_update:
		return
	
	if !player:
		return
	
	update_player(player)
	
	if !equipped_gun:
		return
	
	update_gun(equipped_gun)

func change_visibilty() -> void:
	canvas_layer.visible = !canvas_layer.visible
	coins.visible = !coins.visible
	bombs.visible = !bombs.visible

func gun_reload(gun: GunBase) -> void:
	if !gun:
		return
	var mod: int = gun.max_ammo - gun.actual_clip
	print("MOD IN OBJPISTOL: " + str(mod))
	for i in range(mod):
		gun_component._stack()
		await get_tree().create_timer(.01).timeout

func gun_shoot() -> void:
	gun_component._unstack()

func gun_drop() -> void:
	gun_component.drop_gun()

func player_take_damage(damage: int) -> void:
	for i in range(damage):
		_heart_unstack()

func player_heal(player_to_heal: Player, heal_count: int = 0) -> void:
	var mod: int
	if heal_count == 0:
		mod = player.max_health - player.actual_health
	else:
		mod = heal_count 
	for i in mod:
		_heart_stack()

func _heart_stack() -> void:
	heart_component._stack()

func _heart_unstack() -> void:
	heart_component._unstack()

func update_player(player: Player) -> void:
	_update_heart(player.actual_health)
	_update_itens(player.coins, player.bombs)

func update_gun(gun: GunBase) -> void:
	if !gun:
		return
	
	_update_ammo(gun)

func _update_heart(_count) -> void:
	if heart_component:
		heart_component._update_hearts(_count)

func _update_ammo(gun: GunBase) -> void:
	pass

func _update_itens(_coins: int, _bombs: int) -> void:
	if itens_component:
		itens_component._update(_coins, _bombs)

func _set_ammo(_count: int) -> void:
	if gun_component:
		gun_component.update_ammo(_count)

func _equip_gun(gun_to_equip: GunBase) -> void:
	if equipped_gun:
		gun_drop()
	
	equipped_gun = gun_to_equip
	gun_component._set_texture(equipped_gun._get_texture())
	gun_component._set_ammo(equipped_gun.max_ammo)
	equipped_gun.gun_reload.connect(gun_reload.bind(equipped_gun))
	equipped_gun.gun_shoot.connect(gun_shoot)
