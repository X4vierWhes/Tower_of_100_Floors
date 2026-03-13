extends Node
class_name ItensComponent

@export_category("Configurações")
@export var coins_label: RichTextLabel
@export var bombs_label: RichTextLabel

func _update(_coins: int, _bombs: int) -> void:
	_update_coins(_coins)
	_update_bombs(_bombs)

func _update_coins(_count: int) -> void:
	coins_label.text = "[wave]" + str(_count) + "[/wave]"

func _update_bombs(_count: int) -> void:
	bombs_label.text = "[wave]" + str(_count) + "[/wave]"
