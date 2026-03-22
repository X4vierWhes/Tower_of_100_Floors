extends GunBase
class_name Pistol

@onready var circular_progress_bar_component: CircularProgressBar = $CircularProgressBarComponent
@onready var shoot_point: Marker2D = $shoot_point

const TEX_PISTOL: String = "res://Resources/images/guns/Pistol_Solo.png"

var tween: Tween

func reload() -> void:
	if !gui_pointer:
		return
	can_shoot = false
	circular_progress_bar_component.set_position(player_pointer.global_position)
	circular_progress_bar_component.set_scale(Vector2(0.1,0.1))
	circular_progress_bar_component.loading()
	await circular_progress_bar_component.animation_end
	gui_pointer.gun_reload(self)
	can_shoot = true
	

func shoot() -> void:
	if !gui_pointer:
		return
	
	can_shoot = false
	gui_pointer.gun_shoot(self)
	_create_bullet()
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true
	

func _create_bullet() -> void:
	var new_bullet = OBJ_BULLET.instantiate() as Bullet
	new_bullet.global_position = shoot_point.global_position
	new_bullet.global_rotation = shoot_point.global_rotation
	new_bullet.set_damage(damage)
	shoot_point.add_child(new_bullet)
	new_bullet._throw_item(1)

func _get_texture() -> TextureRect:
	var tex = TextureRect.new()
	tex.texture = load(TEX_PISTOL)
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	tex.custom_minimum_size = Vector2(32, 32)
	tex.top_level = true
	return tex

func _get_stats() -> int:
	return actual_clip
