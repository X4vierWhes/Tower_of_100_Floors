extends StaticBody2D
class_name Door

@export var state: String = "closed"

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	animated_sprite_2d.play(state)
	if state == "open":
		collision_shape_2d.disabled = true

func open_door() -> void:
	state = "open"

func close_door() -> void:
	state = "closed"
