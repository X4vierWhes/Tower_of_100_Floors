extends GunBase
class_name Shotgun

@onready var anim: AnimatedSprite2D = $anim
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var circular_progress_bar_component: CircularProgressBar = $CircularProgressBarComponent

const SHOTGUN_TEX: String = "uid://bfxmua2j1ovg2"

func _ready() -> void:
	animation_player.play("idle")

func shoot() -> void:
	print("Actual clip:", actual_clip)
	actual_clip -= 1
	animation_player.play("shooting")
	await animation_player.animation_finished
	animation_player.play("idle")
	print("Actual clip before:", actual_clip)

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
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	tex.custom_minimum_size = Vector2(32, 32)
	tex.top_level = true
	return tex

func do_damage(body: CharacterInterface, damage_mult: int) -> void:
	pass

func _on_close_range_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_mid_range_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_far_range_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
