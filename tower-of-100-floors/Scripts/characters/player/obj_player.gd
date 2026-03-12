extends CharacterBody2D
class_name Player

@export_category("Parameters")
@export var speed: float = 300.0
@export var health: int = 8

var death: bool = false
var has_gun: bool = false

@onready var anim_player: AnimatedSprite2D = $animPlayer
@onready var father: Game = get_parent() as Game
@onready var guns_pivot: Marker2D = $guns_pivot
@onready var pistol: Pistol

func _ready() -> void:
	pass

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
	
	if has_gun && pistol:
		pistol.equipped_process(self)

func equip_gun(gun: Pistol) -> void:
	pistol = gun as Pistol
	guns_pivot.add_child(pistol)
	has_gun = true
	
