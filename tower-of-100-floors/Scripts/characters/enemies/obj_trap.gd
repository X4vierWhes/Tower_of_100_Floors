extends CharacterInterface
class_name Trap

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $attack_area
@onready var damage: int = 2
@onready var state: String = "idle"

func _ready() -> void:
	animated_sprite_2d.play(state)
	attack_area.monitoring = false

func _process(_delta: float) -> void:
	animated_sprite_2d.play(state)
	if state == "preparing":
		await get_tree().create_timer(2.0).timeout
		state = "attack"
	elif state == "attack":
		attack_area.monitoring = true
		await get_tree().create_timer(1.0).timeout
		state = "idle"
	else:
		attack_area.monitoring = false

func _on_collision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		state = "preparing"


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("_take_damage"):
		body._take_damage(damage)
