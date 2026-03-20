extends UsableItem
class_name Bullet

@export_category("Configurações")
@export var damage: int = 10
@export var bullet_speed: float = 1000.0

var travelled_distance: float = 0.0
const range_distance: float = 1200.0
var direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	
	if travelled_distance >= range_distance:
		queue_free()

func _on_bullet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") && body.has_method("_take_damage"):
		body._take_damage(damage)
	queue_free()

func set_damage(new_damage: int) -> void:
	damage = new_damage
