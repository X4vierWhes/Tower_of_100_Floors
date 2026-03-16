extends Node
class_name DoorAndPlatesComponent

var _doors: Array[Door] = []

func append_doors(d: Door) -> void:
	if d:
		_doors.append(d)

func apply_next_room() -> void:
	for i in _doors:
		i.state = "open"
