extends CharacterInterface
class_name Bee

@onready var anim: AnimatedSprite2D = $anim
@onready var can_take_damage: bool = true
@onready var player_pointer: Player = null
var tween: Tween
var state: String = "searching"

func _ready() -> void:
	if anim.material:
		anim.material = anim.material.duplicate()
	anim.play("idle")
	enemie_control()

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


func _on_range_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
