extends Node2D
class_name ImpactComponent

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var character: CharacterInterface = null

func _ready() -> void:
	animated_sprite_2d.hide()
	set_process(false)

func _process(_delta: float) -> void:
	animated_sprite_2d.global_position = character.global_position

func play_impact(characte: CharacterInterface) -> void:
	character = characte
	set_process(true)
	animated_sprite_2d.show()
	animated_sprite_2d.play("impact")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.hide()
