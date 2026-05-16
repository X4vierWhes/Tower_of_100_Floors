extends CharacterInterface
class_name Player

@export_category("Parameters")
@export var impact_component: ImpactComponent
@export var input_component: InputComponent
@export var dash_force:float = 3.0
@export var dash_cooldown: float = 1.4
@export var dash_duration: float = 0.5
@export var acceleration: float = 0.25

@onready var father: Game = get_parent() as Game
@onready var guns_pivot: Marker2D = $guns_pivot

var camera: GlobalCamera = null
var gun: GunBase = null
var has_gun: bool = false
var can_dash: bool = true
var is_dashing: bool = false

signal update_player(action_name: String, action_count: int)
signal equipped_gun(new_gun: GunBase)

func _ready() -> void:
	camera = Globals.global_camera as GlobalCamera
	if input_component:
		input_component.on_dash.connect(dash)
		input_component.on_throw.connect(throw_item)
		input_component.shoot.connect(_shoot)
		input_component.reload.connect(_reload)

#region Player
func _process(_delta: float) -> void:
	if !death && !Globals.is_paused:
		_update(_delta)

func _update(_delta: float) -> void:
	guns_pivot_update()
	if is_knockbacking:
		_knockbacking_update(_delta)
	else:
		_move()

func guns_pivot_update() -> void:
	if input_component.is_using_controller:
		if input_component.look_direction.length() > 0.1:
			guns_pivot.rotation = input_component.look_direction.angle()
	else:
		guns_pivot.look_at(input_component.look_direction)
	
	guns_pivot.scale.y = -1 if guns_pivot.global_rotation_degrees > 90 || guns_pivot.global_rotation_degrees < -90 else 1
func _move(_direction: Vector2 = Vector2.ZERO) -> void:
	_verify_dashing_collision()
	
	var direction: Vector2 = input_component.input_direction
	var speed_mult: float = dash_force if is_dashing else 1.0
	
	var target = direction * (speed * speed_mult)
	velocity = velocity.lerp(target, acceleration)
	
	move_and_slide()
	
	_handle_animations()

func _handle_animations() -> void:
	if velocity.length() > 10.0:
		anim.play("run")
	else:
		anim.play("idle")
	
	anim.flip_h = true if guns_pivot.global_rotation_degrees > 90 || guns_pivot.global_rotation_degrees < -90 else false

func _verify_hole_collision() -> void:
	var is_in_hole: bool = test_move(global_transform, Vector2(0, 0.01))
	if is_in_hole:
		
		print("esta no buraco")

func dash() -> void:
	can_dash = false
	is_dashing = true
	set_collision_mask_value(6, false)
	_dashing_effect()
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	set_collision_mask_value(6, true)
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _verify_dashing_collision() -> void:
	if !is_dashing || get_slide_collision_count() == 0:
		return
	
	for i in get_slide_collision_count():
		var slide = get_slide_collision(i)
		if is_instance_valid(slide):
			if !slide.get_collider().is_in_group("Player") && is_dashing:
				is_dashing = false
				set_collision_mask_value(6, true)
				_verify_hole_collision()
				camera.apply_shake(1.2)
				return

func _dashing_effect() -> void:
	while is_dashing:
		var ghost: AnimatedSprite2D = anim.duplicate()
		
		ghost.material = ShaderMaterial.new()
		ghost.material.shader = Globals.GHOST_MATERIAL
		ghost.material.set_shader_parameter("glitch_frequency", 10.0)
		ghost.material.set_shader_parameter("glitch_duration", 0.5)
		ghost.material.set_shader_parameter("scanline_intensity", 1.0)
		ghost.material.set_shader_parameter("noise_intensity", 0.8)
		get_parent().add_child(ghost)
		ghost.global_position = global_position
		ghost.flip_h = anim.flip_h
		ghost.play(anim.animation)
		ghost.frame = anim.frame
		ghost.stop()
		
		var tween = create_tween()
		tween.tween_property(ghost, "modulate:a", 0.0, 0.2) 
		tween.finished.connect(func(): ghost.queue_free())
		
		await get_tree().create_timer(0.03).timeout

func throw_item(_item_to_use: Item) -> void: #logica para lançar futuros itens em desenvolvimento
	if bombs <= 0:
		return
	
	var item_instance: Item = _item_to_use
	
	get_parent().add_child(item_instance)
	
	item_instance.global_position = global_position
	var throw_dir: Vector2 = Vector2.ZERO
	if input_component.is_using_controller:
		throw_dir = input_component.look_direction.normalized()
	else:
		throw_dir = global_position.direction_to(input_component.look_direction)
	item_instance.direction = throw_dir
	item_instance.rotation = item_instance.direction.angle()
	item_instance._activate_item()
	bombs -= 1
	update_player.emit("use_item")

func _take_damage(damage: int) -> void:
	if god_mode || !can_take_damage || is_dashing || actual_health < 0:
		return
	
	can_take_damage = false
	update_player.emit("damage", damage)
	actual_health -= damage
	impact_component.play_impact(self)
	_create_damage_label()
	
	if actual_health <= 0:
		anim.play("death")
		death = true
		await get_tree().create_timer(1.0).timeout
		is_death.emit()
	
	_damage_effect()
	await get_tree().create_timer(0.7).timeout
	can_take_damage = true

func _damage_effect() -> void:
	if anim.material == null:
		anim.material = ShaderMaterial.new()
		anim.material.shader = Globals.DAMAGE_MATERIAL

	var tween = create_tween()
	
	var mat = anim.material
	
	var shader_setter = func(value: float):
		if mat:
			mat.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.55, 0.0, 0.2)

func _heal(heal_count: int) -> void:
	actual_health += heal_count
	update_player.emit("heal", heal_count)

func _get_stats() -> Vector3:
	return Vector3(actual_health, coins, bombs)
#endregion

#region Gun
func _equip(item: GunBase) -> void:
	if has_gun: #Fazer logica de dropar arma atual para trocar por nova
		var drop_item: InteractableItem =  gun.get_drop_item()
		Globals.item_component._drop_item(drop_item, global_position)
		gun.queue_free()
		gun = null
	
	gun = item as GunBase
	gun._update_item_actual_stats()
	gun.global_position.x += 10.0
	
	guns_pivot.add_child(gun)
	
	gun.set_process(true)
	equipped_gun.emit(gun)
	has_gun = true

func _shoot() -> void:
	if !gun: return
	gun.shoot(knockback_force)

func _reload() -> void:
	if !gun: return
	gun.reload()

func _get_gun() -> GunBase:
	return gun
#endregion
