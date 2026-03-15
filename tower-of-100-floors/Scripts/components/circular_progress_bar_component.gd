extends Node
class_name CircularProgressBar

@export_category("Configurações")
@export var texture: TextureProgressBar
@export var loading_time: float = 3.0
@export var gun: Item
var tween: Tween
signal animation_end

func _ready() -> void:
	texture.visible = false

func _process(delta: float) -> void:
	set_position(gun.global_position)

func loading() -> void:
	if tween && tween.is_running():
		tween.kill()
	texture.visible = true
	texture.value = texture.min_value
	texture.top_level = true
	tween = create_tween()
	
	tween.tween_property(texture, "value", texture.max_value, loading_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.finished.connect(func() : _invisible())

func _invisible() -> void:
	texture.visible = false
	texture.value = texture.min_value
	emit_signal("animation_end")

func set_scale(scale: Vector2) -> void:
	texture.scale = scale

func set_loading_time(time: float) -> void:
	loading_time = time

func set_position(pos: Vector2) -> void:
	texture.global_position = pos
	texture.global_position.x -= 15.0
