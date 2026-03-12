extends Node
class_name CircularProgressBar

@export_category("Configurações")
@export var texture: TextureProgressBar
@export var loading_time: float = 3.0
var tween: Tween

func loading() -> void:
	if tween && tween.is_running():
		tween.kill()
	texture.visible = true
	texture.value = texture.min_value
	tween = create_tween()
	
	tween.tween_property(texture, "value", texture.max_value, loading_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(func() : _invisible())

func _invisible() -> void:
	texture.visible = false
	texture.value = texture.min_value

func set_scale(scale: Vector2) -> void:
	texture.scale = scale
