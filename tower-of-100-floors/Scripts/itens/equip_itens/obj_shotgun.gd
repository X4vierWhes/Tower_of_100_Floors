extends GunBase
class_name Shotgun

@onready var anim: AnimatedSprite2D = $anim
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var circular_progress_bar_component: CircularProgressBar = $CircularProgressBarComponent
@onready var shoot_point: Marker2D = %shoot_point

const SHOTGUN_TEX: String = "uid://qrw8xmgu32xh"

func shoot() -> void:
	if !gui_pointer:
		return

func reload() -> void:
	if !gui_pointer:
		return
	can_shoot = false
	is_reloading = true
	circular_progress_bar_component.set_position(global_position)
	circular_progress_bar_component.set_scale(Vector2(0.1,0.1))
	circular_progress_bar_component.loading()
	await circular_progress_bar_component.animation_end
	gui_pointer.gun_reload(self)
	can_shoot = true
	is_reloading = false

func _get_texture() -> TextureRect:
	var tex = TextureRect.new()
	tex.texture = load(SHOTGUN_TEX)
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tex.custom_minimum_size = Vector2(128, 128)
	#tex.scale = Vector2(1.5, 1.5)
	tex.top_level = true
	return tex

func _create_bullet() -> void:
	pass
