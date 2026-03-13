extends CharacterBody2D
class_name Item

@export_category("Configurações")
@export var item_name: String = "null"
@export var damage: int = 2
@export var max_ammo: int = 22
@onready var actual_clip: int = 0
const DIR_DROP_ITEM: String = "res://Scenes/itens/iteractable_itens/obj"
