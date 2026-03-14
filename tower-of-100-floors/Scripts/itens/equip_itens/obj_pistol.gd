extends Item
class_name Pistol

const TEX_PISTOL: String = "res://Resources/images/pistol/Pistol_Solo.png"
@onready var can_shoot: bool = true
@onready var circular_progress_bar_component: CircularProgressBar = $CircularProgressBarComponent
@export var shoot_delay: float = 0.6

func _process(_delta: float) -> void:
	#print("Atualizando objPistol")
	pass

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
	#print("ACTUAL CLIP AFTER SHOOT: " + str(actual_clip))
	can_shoot = false
	gui_pointer.gun_shoot(self)
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true
	#print("ACTUAL CLIP BEFORE SHOOT: " + str(actual_clip))

func _get_texture() -> TextureRect:
	var tex = TextureRect.new()
	tex.texture = load(TEX_PISTOL)
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	tex.custom_minimum_size = Vector2(32, 32)
	tex.top_level = true
	return tex

func _get_stats() -> int:
	return actual_clip
