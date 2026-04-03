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


func _take_damage(damage: int) -> void:
	if !can_take_damage: return
	
	if tween && tween.is_running():
		tween.kill()
	
	can_take_damage = false
	tween = create_tween()
	_create_damage_label()
		
	var shader_setter = func(value: float):
		anim.material.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.55, 0.0, 0.2)
	
	await tween.finished
	_calc_damage(damage)

func _calc_damage(damage: int) -> void:
	actual_health -= damage
	if actual_health > 0:
		can_take_damage = true
	else:
		set_process(false)
		emit_signal("is_death")


func _do_damage(body:Node2D) -> void:
	if body.is_in_group("Player") and body is CharacterInterface:
		body._take_damage(attack_damage)
		attack_area.set_deferred("monitoring", false)
		await get_tree().create_timer(0.2).timeout
		attack_area.set_deferred("monitoring", true)
