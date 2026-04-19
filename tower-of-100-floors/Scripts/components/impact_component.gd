extends Node2D
class_name ImpactComponent

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var char: CharacterInterface = null

func _ready() -> void:
	animated_sprite_2d.hide()
	set_process(false)

func _process(delta: float) -> void:
	animated_sprite_2d.global_position = char.global_position

func play_impact(character: CharacterInterface) -> void:
	char = character
	set_process(true)
	print("Dei play no impacto")
	animated_sprite_2d.show()
	animated_sprite_2d.play("impact")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.hide()
	print("Terminei o impacto")
