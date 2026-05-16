extends Camera2D
class_name GlobalCamera

var shake_intensity = 0.0
var decay_rate = 5.0
var max_offset = Vector2(20, 15)
@export var noise: FastNoiseLite
var noise_y = 0

func _ready() -> void:
	Globals.global_camera = self

func _process(delta):
	if shake_intensity > 0:
		shake_intensity = lerp(shake_intensity, 0.0, decay_rate * delta)
		
		noise_y += 1
		offset.x = noise.get_noise_2d(100, noise_y) * max_offset.x * shake_intensity
		offset.y = noise.get_noise_2d(200, noise_y) * max_offset.y * shake_intensity
	else:
		offset = lerp(offset, Vector2.ZERO, 10 * delta)

func apply_shake(intensity):
	shake_intensity = intensity
