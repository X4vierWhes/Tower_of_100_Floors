extends Node
class_name EnemiesControl

var _enemiesList: Array[CharacterInterface] = []

signal enemies_empty

func _append_enemie(enemie: CharacterInterface) -> void:
	if enemie:
		_enemiesList.append(enemie)
		enemie.is_death.connect(_del_enemie.bind(enemie))
	

func _del_enemie(enemie: CharacterInterface) -> void:
	if enemie:
		_enemiesList.erase(enemie)
		enemie.queue_free()
	
	if _enemiesList.is_empty():
		emit_signal("enemies_empty")
