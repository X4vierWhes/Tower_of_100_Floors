extends Node
class_name Scripts

static func lengthdir_x(length: float, direction_deg: float) -> float:
	return length * cos(deg_to_rad(direction_deg))

static func lengthdir_y(length: float, direction_deg: float) -> float:
	return length * sin(deg_to_rad(direction_deg))

static func point_direction(x1: float, y1: float, x2: float, y2: float) -> float:
	var dx = x2 - x1
	var dy = y2 - y1
	var angle = rad_to_deg(atan2(dy, dx))
	
	if angle < 0:
		angle += 360.0
	return angle

static func distance_to_object(instance: Node2D, destiny: Node2D) -> float:
	return instance.global_position.distance_to(destiny.global_position)

static func distance_to_point(x1: float, y1: float, x2: float, y2: float) -> float:
	var pos1 = Vector2(x1, y1)
	var pos2 = Vector2(x2, y2)
	return pos1.distance_to(pos2)

static func lerp_custom(start: float, end: float, t: float) -> float:
	return move_toward(start, end, t)

static func sign_custom(value: float) -> int:
	return int(sign(value))
