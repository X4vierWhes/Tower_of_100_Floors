extends Node
class_name GunComponent

@export_category("Configurações")
@export var gun_location: Marker2D
@export var ammo_container: HBoxContainer
@export var max_ammo: int = 22
@onready var _elements: Array[TextureRect] = []
const AMMO_TEX = preload("res://Resources/images/pistol/Ammo.png")

func stack() -> void:
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

func unstack() -> void:
	if !_elements.is_empty():
		var last = _elements.pop_back()
		if is_instance_valid(last):
			last.queue_free()
