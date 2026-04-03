extends CharacterInterface
class_name EnemyInterface

var state:String = "idle"
var navigation_agent:NavigationAgent2D
var attack_damage:int = 1
var attack_area:Area2D

func _ready() -> void:
	super._ready()
	attack_area = $attack_area

func _chase_player() -> void:
	pass

func _do_damage(body:Node2D) -> void:
	if body.is_in_group("Player") and body is CharacterInterface:
		body._take_damage(attack_damage)
		attack_area.set_deferred("monitoring", false)
		await get_tree().create_timer(0.2).timeout
		attack_area.set_deferred("monitoring", true)
