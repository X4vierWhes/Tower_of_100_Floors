extends CharacterInterface
class_name Wizard

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@onready var player_pointer: Player = null
@onready var state: String = "idle"
@onready var can_take_damage: bool = true

var searching_goal: Vector2 = Vector2(10, 5)
var tween: Tween
const MAGIC_SCENE: String = "uid://krmikpan11be"

func _ready() -> void:
	anim.play(state)
	enemie_control()

func _process(delta: float) -> void:
	anim.play(state)
	if state == "run":
		pass
	elif state == "attack":
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


func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pointer = body as Player
		state = "run"


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && player_pointer:
		state = "attack"
		_shoot()
	

func _shoot() -> void:
	pass

func _on_navigation_timer_timeout() -> void:
	pass # Replace with function body.
