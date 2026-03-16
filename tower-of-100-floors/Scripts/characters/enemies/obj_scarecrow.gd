extends CharacterInterface
class_name Scarecrow
# Link sprite scarecrow: https://otsoga.itch.io/scarecrow
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var can_take_damage: bool = true
var tween: Tween

func _ready() -> void:
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	animated_sprite_2d.play("idle")
	enemie_control()


func _take_damage(damage: int) -> void:
	if !can_take_damage: return
	
	if tween && tween.is_running():
		tween.kill()
	
	can_take_damage = false
	tween = create_tween()
	animated_sprite_2d.play("hurt")
	_create_damage_label()
	
	var shader_setter = func(value: float):
		animated_sprite_2d.material.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.55, 0.0, 0.2)
	
	await tween.finished
	can_take_damage = true
	animated_sprite_2d.play("idle")
