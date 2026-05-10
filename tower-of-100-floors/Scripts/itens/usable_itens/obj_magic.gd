extends Item
class_name Magic

@export_category("Configurações")
@export var damage: int = 1
@export var bullet_speed: float = 500.0
var force: float = 150.0

func launch(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()

func _process(delta: float) -> void:
	global_position += direction * bullet_speed * delta
	travelled_distance += bullet_speed * delta
	
	if travelled_distance >= range_distance:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") && body is CharacterInterface:
		body._take_damage(damage)
		var knock_dir: Vector2 = (body.global_position - global_position).normalized()
		body.apply_knockback(knock_dir, force, 0.12)
	

func _on_area_2d_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.is_in_group("Itens"):
		queue_free()
