extends CharacterBody2D
class_name IteractableItem

@export_category("Configurações")
@export var ITEM_NAME: String = "null"
@export var action_name: String = "Interact"
@export var INTERACT_TEXT: String = "Press [F] to "
@export var consumable_item: bool = true

@onready var is_player_in_area: bool = false
@onready var player_pointer: Player = null

const ITENS_DIR: String = "res://Scenes/itens/equip_itens/obj_"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && is_player_in_area:
		_interact()

func _interact() -> void:
	if is_player_in_area && player_pointer && consumable_item:
		player_pointer._equip(_get_item())
		queue_free()

func _get_item() -> Item: #Sobrescrever cenas que herdam
	if ITEM_NAME == "null" && Scripts._search_item(ITENS_DIR, ITEM_NAME):
		return null
	var dir: String = ITENS_DIR + ITEM_NAME + ".tscn"
	var item = load(dir)
	
	if item:
		var instance = item.instantiate() as Item
		return instance
	return null
	

func _get_interact_label_text(item: IteractableItem) -> RichTextLabel:
	var label: RichTextLabel = RichTextLabel.new()
	var font_label = load("res://Resources/font/Daydream DEMO.otf")

	label.add_theme_font_size_override("normal_font_size", 8)
	
	label.add_theme_font_override("normal_font", font_label)
	label.custom_minimum_size = Vector2(200.0, 40.0)
	label.global_position = item.global_position
	label.global_position.x -= 45.0
	label.global_position.y -= 50.0
	label.text = "[shake][color=9ff4e5]" + INTERACT_TEXT + action_name + "[/color][/shake]"
	label.bbcode_enabled = true
	label.top_level = true
	return label
