extends Node2D
class_name InteractableItem

@export_category("Configurações")
@export_subgroup("Imports")
@export var interact_area: Area2D
@export var interact_label: RichTextLabel
@export_subgroup("Item Propertys")
@export var ITEM_NAME: String = "null"
@export var INTERACT_TEXT: String = "Press [F] to "
@export var price: int = 0
@export var consumable_item: bool = true
@export var key_item: bool = false

@onready var is_player_in_area: bool = false
@onready var player_pointer: Player = null

var item_component: ItensControlComponent = null
var stats: ItemStats = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && is_player_in_area:
		_interact()

func _ready() -> void:
	if get_parent() && get_parent() is ItensControlComponent:
		item_component = get_parent()
	if interact_area:
		_init_area2d()
	else:
		push_error("Interactable Item need a Area2D to works")
	if interact_label:
		_init_label()
	top_level = true

func _init_area2d() -> void:
	interact_area.body_entered.connect(on_body_entered)
	interact_area.body_exited.connect(on_body_exited)

func _init_label() -> void:
	interact_label.hide()
	interact_label.text = get_interact_label_text()
	interact_label.global_position.x -= 25.0
	interact_label.add_theme_font_override("normal_font", Globals.FONT_LABEL)
	interact_label.add_theme_font_size_override("normal_font_size", 10)
	interact_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interact_label.size = Vector2(256,256)

func on_body_entered(body: Node2D) -> void:
	interact_label.text = get_interact_label_text()
	if body.is_in_group("Player"):
		interact_label.show()
		is_player_in_area = true
		player_pointer = body as Player

func on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		interact_label.hide()
		is_player_in_area = false

func _interact() -> void:
	if price > player_pointer.coins:
		interact_label.text = "[shake][color=9ff4e5]Not enough money[/color][/shake]"
		return
	if is_player_in_area && player_pointer && consumable_item:
		player_pointer._equip(_get_item())
		player_pointer.coins -= price
		player_pointer.update_player.emit("use_item")
		if item_component && key_item:
			item_component.itens_collected.emit()
		queue_free()

func _get_item() -> Item: #Sobrescrever cenas que herdam
	if ITEM_NAME == "null" && Scripts._search_item(Globals.EQUIPMENTS_DIR, ITEM_NAME):
		return null
	var dir: String = Globals.EQUIPMENTS_DIR + ITEM_NAME + ".tscn"
	var item = load(dir)
	
	if item:
		var instance = item.instantiate() as Item
		instance.set_item_stats(stats)
		return instance
	return null

func get_interact_label_text() -> String:
	if price != 0:
		return "[shake][color=9ff4e5]" + ITEM_NAME + " PRICE: " + str(price)  + "[/color][/shake]"
	return "[shake][color=9ff4e5]" + INTERACT_TEXT + "[/color][/shake]"

func _set_drop_item_stats(new_stats: ItemStats) -> void:
	stats = new_stats

func _get_drop_item_stats() -> ItemStats:
	return stats
