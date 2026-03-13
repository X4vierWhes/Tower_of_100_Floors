extends Node
class_name GunComponent

@export_category("Configurações")
@export var gun_location: Marker2D
@export var ammo_container: HBoxContainer
@export var max_ammo: int = 22
@onready var _elements: Array[TextureRect] = []
const AMMO_TEX = preload("res://Resources/images/pistol/Ammo.png")

func update_ammo(_count: int) -> void:
	if _count > 0:
		for i in range(_count):
			_stack()
	else:
		_count *= -1
		for i in range(_count):
			_unstack()

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
		print(_elements.size())
	else:
		print("Ammo full!")

func _unstack() -> void:
	if !_elements.is_empty():
		var last = _elements.pop_back()
		if is_instance_valid(last):
			last.queue_free()

func _set_texture(texture: TextureRect) -> void:
	texture.global_position = gun_location.global_position
	texture.global_position.x -= 50.0
	texture.global_position.y -= 50.0
	gun_location.add_child(texture)
	texture.use_parent_material = true
