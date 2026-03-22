extends CharacterInterface
class_name Player

@export_category("Parameters")
@export var dash_cooldown: float = 1.4
@export var dash_duration: float = 0.5


const GHOST_MATERIAL = preload("res://shaders/retro_vhs_glitch.gdshader")
const DAMAGE_MATERIAL = preload("res://shaders/flash_and_random_shake.gdshader")

@onready var anim_player: AnimatedSprite2D = $animPlayer
@onready var father: Game = get_parent() as Game
@onready var guns_pivot: Marker2D = $guns_pivot

@export var gui_pointer: GUI
var gun: GunBase = null
var has_gun: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var can_take_damage: bool = true

func _ready() -> void:
	#var parent = get_parent() as Game
	#if parent:
	#	gui_pointer = parent._get_gui()
		update_gui()
	

func _process(_delta: float) -> void:
	if !death:
		_update()

func _update() -> void:
	guns_pivot_update()
	movement_update()
	

func movement_update() -> void:
	_verify_dashing_collision()
	
	if Input.is_action_just_pressed("dash") && can_dash:
		dash()
	
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed_mult: float = dash_force if is_dashing else 1.0
	velocity = direction * (speed * speed_mult)
	move_and_slide()
	
	if velocity.x != 0:
		anim_player.play("run")
	else:
		anim_player.play("idle")
	
	if direction.x != 0:
		anim_player.flip_h = (direction.x < 0)
	

func _verify_dashing_collision() -> void:
	for i in get_slide_collision_count():
		if !get_slide_collision(i).get_collider().is_in_group("Player") && is_dashing:
			is_dashing = false
			return

func guns_pivot_update() -> void:
	guns_pivot.look_at(get_global_mouse_position())
	guns_pivot.scale.y = -1 if guns_pivot.global_rotation_degrees > 90 || guns_pivot.global_rotation_degrees < -90 else 1
	

func dash() -> void:
	can_dash = false
	is_dashing = true
	_dashing_effect()
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _dashing_effect() -> void:
	while is_dashing:
		var ghost: AnimatedSprite2D = anim_player.duplicate()
		
		ghost.material = ShaderMaterial.new()
		ghost.material.shader = GHOST_MATERIAL
		ghost.material.set_shader_parameter("glitch_frequency", 10.0)
		ghost.material.set_shader_parameter("glitch_duration", 0.5)
		ghost.material.set_shader_parameter("scanline_intensity", 1.0)
		ghost.material.set_shader_parameter("noise_intensity", 0.8)
		get_parent().add_child(ghost)
		ghost.global_position = global_position
		ghost.flip_h = anim_player.flip_h
		ghost.play(anim_player.animation)
		ghost.frame = anim_player.frame
		ghost.stop()
		
		var tween = create_tween()
		tween.tween_property(ghost, "modulate:a", 0.0, 0.2) 
		tween.finished.connect(func(): ghost.queue_free())
		
		await get_tree().create_timer(0.03).timeout

func _equip(item: GunBase) -> void:
	gun = item as GunBase
	gun.global_position.x += 10.0
	
	guns_pivot.add_child(gun)
	
	if gui_pointer:
		gun._set_pointers(self, gui_pointer)
	gun.set_process(true)
	if gun: 
		gui_pointer.update_gun(gun)
	

func _take_damage(damage: int) -> void:
	if god_mode || !can_take_damage || is_dashing || actual_health < 0:
		return
	
	can_take_damage = false
	actual_health -= damage
	gui_pointer.player_take_damage(damage)
	_create_damage_label()
	if actual_health <= 0:
		anim_player.play("death")
		death = true
		await get_tree().create_timer(1.0).timeout
		is_death.emit()
	
	_damage_effect()
	await get_tree().create_timer(0.7).timeout
	can_take_damage = true

func _damage_effect() -> void:
	if anim_player.material == null:
		anim_player.material = ShaderMaterial.new()
		anim_player.material.shader = DAMAGE_MATERIAL

	var tween: Tween = create_tween()
	
	var mat = anim_player.material
	
	var shader_setter = func(value: float):
		if mat:
			mat.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.55, 0.0, 0.2)
	

func _heal(heal_count: int) -> void:
	gui_pointer.player_heal(heal_count)
	actual_health = max_health

func _get_stats() -> Vector3:
	return Vector3(actual_health, coins, bombs)

func update_gui() -> void:
	if gui_pointer:
		gui_pointer.update_player(self)

func _get_gun() -> GunBase:
	return gun
