extends ProjectileGun
class_name Shotgun

const SHOTGUN_TEX: String = "uid://qrw8xmgu32xh"
@onready var sprite_2d: Sprite2D = $Sprite2D

func _get_texture() -> Sprite2D:
	var texture: Sprite2D = sprite_2d.duplicate()
	texture.scale = Vector2(1.8, 1.8)
	return texture
