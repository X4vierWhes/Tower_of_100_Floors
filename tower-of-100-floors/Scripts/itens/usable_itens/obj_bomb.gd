extends UsableItem
class_name Bomb

@export_category("Parameters")
@export var damage: int = 10.0
@export var bomb_speed: float = 100.0

@onready var explosion_area: Area2D = $explosion_area
@onready var explosion_particles: GPUParticles2D = $explosion_particles
@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	super._ready()
	explosion_area.set_deferred("monitoring", false)
	explosion_particles.emitting = false


func _process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * bomb_speed * delta
	travelled_distance += bomb_speed * delta
	
	if travelled_distance >= range_distance:
		set_process(false)
		_explode()

func _explode() -> void:
	var tween: Tween = create_tween()
	
	var shader_setter = func(value: float):
		if sprite.material:
			sprite.material.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.0, 1.0, 1.0)
	await tween.finished
	tween.kill()
	sprite.visible = false
	explosion_particles.emitting = true
	explosion_area.set_deferred("monitoring", true)
	await get_tree().create_timer(.2).timeout
	explosion_area.set_deferred("monitoring", false)
	explosion_particles.emitting = false
	await get_tree().create_timer(explosion_particles.lifetime).timeout
	queue_free()


func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") && body.has_method("_take_damage"):
		body._take_damage(damage)
