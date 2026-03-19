extends UsableItem
class_name Magic

@export_category("Configurações")
@export var damage: int = 1
@export var bullet_speed: float = 500.0

var travelled_distance: float = 0.0
const range_distance: float = 1200.0
var direction: Vector2 = Vector2.ZERO

func launch(dir: Vector2) -> void:
	print("Ativei magia")
	direction = dir.normalized()
	rotation = direction.angle()
	print("Direction: " + str(direction) + " Rotation: " + str(rotation))

func _process(delta: float) -> void:
	global_position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	
	if travelled_distance >= range_distance:
		print("Apaguei magia")
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.has_method("_take_damage"):
			body._take_damage(damage)
			
	if !body.is_in_group("Enemies"):
		queue_free()
