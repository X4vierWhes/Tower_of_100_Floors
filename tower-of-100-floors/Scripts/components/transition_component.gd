extends Node
class_name TransitionComponent

@export var background: ColorRect
@onready var tween: Tween = create_tween()
@onready var canvas_layer: CanvasLayer = $CanvasLayer
signal on_transition_end
var shader_material: ShaderMaterial

func _ready() -> void:
	shader_material = background.material as ShaderMaterial
	tween = create_tween()
	canvas_layer.layer = 5

func _total_background(seconds: float = 1.0) -> void:
	shader_material.set_shader_parameter("animation_progress", 1.0)

func fade_in(seconds: float = 1.0) -> void:
	_check_tween()
	canvas_layer.layer = 5
	tween.tween_method(
		Callable(self, "_update_animation_progress"), 0.0, 1.0, seconds
	)
	await tween.finished
	emit_signal("on_transition_end")

func fade_out(seconds: float = 1.0) -> void:
	_check_tween()
	canvas_layer.layer = 5
	tween.tween_method(
		Callable(self, "_update_animation_progress"), 1.0, 0.0, seconds
	)
	await tween.finished
	canvas_layer.layer = -1
	emit_signal("on_transition_end")

func _check_tween() -> void:
	if tween:
		tween.kill()
		tween = create_tween()

func _update_animation_progress(value: float) -> void:
	shader_material.set_shader_parameter("animation_progress", value)
