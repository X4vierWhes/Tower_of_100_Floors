extends Item
class_name Bullet

@export_category("Configurações")
@export var damage: int = 10
@export var bullet_speed: float = 1000.0
@onready var bullet_area: Area2D = $bulletArea
var force: float = 110.0

func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	
	if travelled_distance >= range_distance:
		queue_free()

func _on_bullet_area_body_entered(body: Node2D) -> void:
	bullet_area.set_deferred("monitoring", false)
	if body.is_in_group("Enemies") && body.has_method("_take_damage") && body is CharacterInterface:
		body._take_damage(damage)
		var knock_dir: Vector2 = (body.global_position - global_position).normalized()
		body.apply_knockback(knock_dir, force, 0.12)
	queue_free()

func set_damage(new_damage: int) -> void:
	damage = new_damage

func set_force(new_force: float) -> void:
	force = new_force
