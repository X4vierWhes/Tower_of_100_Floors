extends CharacterBody2D
class_name Player

@export_category("Parameters")
@export var speed: float = 300.0
@export var health: int = 8
var death: bool = false
@onready var anim_player: AnimatedSprite2D = $animPlayer

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if velocity.x != 0:
		anim_player.play("run")
	else:
		anim_player.play("idle")
	
	if direction.x != 0:
		anim_player.flip_h = (direction.x < 0)
