extends CharacterBody2D
class_name CharacterInterface

@export_category("Parameters")
@export var speed: float = 300.0
@export var health: int = 8
@export var coins: int = 0
@export var bombs: int = 0
@export var dash_force: float = 1.5

var death: bool = false

func _ready() -> void:
	if get_parent() && get_parent() is EnemiesControl:
		var parent = get_parent() as EnemiesControl
		parent._append_enemie(self)
	

func _take_damage(damage: int) -> void:
	pass

func _create_damage_label() -> void:
	pass
