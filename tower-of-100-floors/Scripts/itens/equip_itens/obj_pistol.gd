extends Item
class_name Pistol

@export var shoot_delay: float = 0.6

@onready var can_shoot: bool = true
@onready var circular_progress_bar_component: CircularProgressBar = $CircularProgressBarComponent
@onready var shoot_point: Marker2D = $shoot_point

const OBJ_BULLET = preload("uid://uy71c1b3cb13")
const TEX_PISTOL: String = "res://Resources/images/pistol/Pistol_Solo.png"

var tween: Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") && actual_clip > 0 && can_shoot:
		shoot()
	elif event.is_action_pressed("attack") && actual_clip == 0 && can_shoot || event.is_action_pressed("reload") && can_shoot:
		reload()

func reload() -> void:
	if !gui_pointer:
		return
	can_shoot = false
	circular_progress_bar_component.set_position(player_pointer.global_position)
	circular_progress_bar_component.set_scale(Vector2(0.1,0.1))
	circular_progress_bar_component.loading()
	await circular_progress_bar_component.animation_end
	#print("Sinal recebido em objPistol")
	gui_pointer.gun_reload(self)
	can_shoot = true
	

func shoot() -> void:
	if !gui_pointer:
		print("GUI POINTER NULL IN PISTOL")
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
