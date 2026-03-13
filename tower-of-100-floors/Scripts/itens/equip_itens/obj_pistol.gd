extends Item
class_name Pistol

const TEX_PISTOL: String = "res://Resources/images/pistol/Pistol_Solo.png"


func _get_texture() -> TextureRect:
	var tex = TextureRect.new()
	tex.texture = load(TEX_PISTOL)
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	tex.custom_minimum_size = Vector2(32, 32)
	tex.top_level = true
	return tex

func _get_stats() -> int:
	return actual_clip
