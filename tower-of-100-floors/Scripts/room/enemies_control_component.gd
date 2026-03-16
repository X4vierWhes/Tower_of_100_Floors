extends Node
class_name EnemiesControl

@onready var _enemiesList: Array[CharacterInterface] = []

func _append_enemie(enemie: CharacterInterface) -> void:
	if enemie:
		print("Adicionei inimigo na enemie control")
		_enemiesList.append(enemie)
	

func _del_enemie(enemie: CharacterInterface) -> void:
	if enemie:
		_enemiesList.erase(enemie)
		enemie.queue_free()
