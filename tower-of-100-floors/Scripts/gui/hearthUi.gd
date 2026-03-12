extends Node
class_name HearthUI

@onready var hearth_container: HBoxContainer = $hearthContainer
@export_category("Configurações")
@export var max_hearth: int = 8
@onready var _elements: Array = []

#Vai agir como uma pilha, onde ultimo sai
func stack() -> void:
	pass

func unstack() -> void:
	pass
