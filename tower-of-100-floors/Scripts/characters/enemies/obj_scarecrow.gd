extends CharacterInterface
class_name Scarecrow
# Link sprite scarecrow: https://otsoga.itch.io/scarecrow
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if animated_sprite_2d.material:
		animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
	animated_sprite_2d.play("idle")

func _take_damage(_damage: int) -> void:
	if !can_take_damage: return
	
	can_take_damage = false
	var tween = create_tween()
	
	var shader_setter = func(value: float):
		animated_sprite_2d.material.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.55, 0.0, 0.2)
	_create_damage_label()
	animated_sprite_2d.play("hurt")
	
	await tween.finished
	can_take_damage = true
	animated_sprite_2d.play("idle")
