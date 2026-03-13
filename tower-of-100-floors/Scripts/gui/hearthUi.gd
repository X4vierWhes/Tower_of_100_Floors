extends Node
class_name HeartComponent

#@onready var hearth_container: HBoxContainer = $hearthContainer
const HEART_TEX = preload("res://Resources/images/player/Heart.png")
@export_category("Configurações")
@export var max_heart: int = 8
@export var heart_container: HBoxContainer
@onready var _elements: Array[TextureRect] = []

func _update_hearts(_count: int) -> void:
	if _elements.size() >= max_heart:
		return
	
	if _count > 0:
		for i in range(_count):
			
			if _elements.size() < max_heart:
				_stack()
			else:
				break

#Vai agir como uma pilha, onde ultimo sai
func _stack() -> void: #Empilhar
	if _elements.size() < max_heart:
		var heart: TextureRect = TextureRect.new()
		heart.texture = HEART_TEX
		heart.expand_mode =TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
		heart.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart.custom_minimum_size = Vector2(32, 32)
		heart_container.add_child(heart)
		heart.use_parent_material = true
		_elements.append(heart)
		print(_elements.size())
	else:
		print("Hearth full!")
	

func _unstack() -> void: #Desempilhar
	if !_elements.is_empty():
		var last = _elements.pop_back()
		if is_instance_valid(last):
			last.queue_free()
	
