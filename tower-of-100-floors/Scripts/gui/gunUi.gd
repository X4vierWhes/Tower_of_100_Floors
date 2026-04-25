extends Node
class_name GunComponent

@export_category("Configurações")
@export var gun_location: Marker2D
@export var ammo_container: HBoxContainer
@export var max_ammo: int = 22

var gun_texture: TextureRect = null
var _elements: Array[TextureRect] = []
var equipped_gun: GunBase = null
const AMMO_TEX = preload("res://Resources/images/guns/Ammo.png")

func set_gun(gun_to_equip: GunBase) -> void:
	if !equipped_gun:
		_set_texture(gun_to_equip._get_texture())
		equipped_gun = gun_to_equip
		equipped_gun.update_gun.connect(on_update_gun)
		_init_ui()
		return

func on_update_gun(action_name: String) -> void:
	#print("ON GUN UI ACTION: " + action_name)
	match action_name:
		"reload":
			gun_reload()
		"shoot":
			gun_shoot()
		"drop":
			gun_drop()
		_:
			printerr("unknown action")

func _init_ui() -> void:
	if equipped_gun:
		for i in range(equipped_gun.actual_clip):
			_stack()

func _set_texture(texture: TextureRect) -> void:
	gun_texture = texture
	gun_texture.global_position = gun_location.global_position
	gun_texture.global_position.x -= 50.0
	gun_texture.global_position.y -= 50.0
	gun_location.add_child(gun_texture)
	gun_texture.material = gun_location.material.duplicate()

func gun_shoot() -> void:
	_unstack()

func gun_reload() -> void:
	var reload_count: int = equipped_gun.max_ammo - equipped_gun.actual_clip
	for i in range(reload_count):
		_stack()
		await get_tree().create_timer(0.02).timeout

func gun_drop() -> void:
	for i in equipped_gun.max_ammo: #retirando munições
		_unstack()
	
	gun_texture.queue_free()
	gun_texture = null
	equipped_gun = null

func _stack() -> void:
	if _elements.size() < max_ammo:
		var ammo: TextureRect = TextureRect.new()
		ammo.texture = AMMO_TEX
		ammo.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		ammo.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		ammo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ammo.custom_minimum_size = Vector2(4, 4)
		ammo_container.add_child(ammo)
		_elements.append(ammo)

func _unstack() -> void:
	if !_elements.is_empty():
		var last = _elements.pop_back()
		if is_instance_valid(last):
			last.queue_free()
