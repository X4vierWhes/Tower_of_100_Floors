extends ProjectileGun
class_name Pistol

const TEX_PISTOL: String = "uid://dbl7y7c7gwiif"
var tween: Tween
@onready var sprite_2d: Sprite2D = $Sprite2D

func _get_texture() -> Sprite2D:
	var texture: Sprite2D = sprite_2d.duplicate()
	texture.scale = Vector2(1.2, 1.2)
	return texture
