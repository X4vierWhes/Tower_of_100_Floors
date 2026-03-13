extends StaticBody2D
class_name IteractableItem

@export_category("Configurações")
@export var ITEM_NAME: String = "null"
@export var action_name: String = "Interact"
@export var INTERACT_TEXT: String = "Press [F] to "
const ITENS_DIR: String = "res://Scenes/itens/equip_itens/"

func _get_item() -> Item: #Sobrescrever cenas que herdam
	if ITEM_NAME == "null" && search_item(ITEM_NAME):
		return null
	
	return null
	

func search_item(item_name: String) -> bool:
	var dir = DirAccess.open(ITENS_DIR)
	
	if dir:
		dir.list_dir_begin()
		var archive_name = dir.get_next()
		while archive_name != "":
			if not dir.current_is_dir():
				print("Arquivo encontrado: " + archive_name)
			archive_name = dir.get_next()
		dir.list_dir_end()
	else:
		return false
	return true

func _get_interact_label_text() -> RichTextLabel:
	var label: RichTextLabel = RichTextLabel.new()
	label.text = "[shake]" + INTERACT_TEXT + action_name + "[/shake]"
	label.bbcode_enabled = true
	return label
