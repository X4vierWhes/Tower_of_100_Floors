extends ProjectileGun
class_name Uzi

@onready var sprite_2d: Sprite2D = $Sprite2D

func _get_texture() -> Sprite2D:
	var texture: Sprite2D = sprite_2d.duplicate()
	texture.scale = Vector2(10.0, 10.0)
	return texture
