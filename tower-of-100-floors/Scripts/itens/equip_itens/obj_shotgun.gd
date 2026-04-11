extends GunBase
class_name Shotgun

const SHOTGUN_TEX: String = "uid://qrw8xmgu32xh"

func _get_texture() -> TextureRect:
	var tex = TextureRect.new()
	tex.texture = load(SHOTGUN_TEX)
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tex.custom_minimum_size = Vector2(128, 128)
	#tex.scale = Vector2(1.5, 1.5)
	tex.top_level = true
	return tex
