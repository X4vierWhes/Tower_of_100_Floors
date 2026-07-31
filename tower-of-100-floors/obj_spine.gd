extends EnemyInterface
class_name Spine

@export var turning_spd: float = 150.0

@onready var marker_2d: Marker2D = $Marker2D

func _process(delta: float) -> void:
	move(delta)
	rotate_marker(delta)

func move(delta: float) -> void:
	_verify_collision()
	global_position.x += speed * delta
	move_and_slide()
	pass

func rotate_marker(delta: float) -> void:
	marker_2d.rotation += deg_to_rad(turning_spd) * delta

func _verify_collision() -> void:
	if get_slide_collision_count() == 0:
		return
	for i in get_slide_collision_count():
		var slide = get_slide_collision(i)
		if is_instance_valid(slide):
			speed *= -1
			return
