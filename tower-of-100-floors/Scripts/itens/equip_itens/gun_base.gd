extends Item
class_name GunBase

@export_category("Gun Base Parameters")
@export var damage: int = 10
@export var max_ammo: int = 22
@export var actual_clip: int = 22
@export var bullet_count: int = 1
@export_range(0.1, 2.0) var shoot_delay: float = 0.6
@export_range(0, 360) var arc: float = 0
@export_range(0.8, 3.0) var reload_time: float = 0.8
#@export_range(200, 1200) var range: float = 1200
@export var OBJ_BULLET: PackedScene
@export var shoot_point: Marker2D
@export var circular_progress_bar_component: CircularProgressBar

var can_shoot: bool = true
var is_reloading: bool = false
const bullet_reload_time: float = 0.04

func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack") && actual_clip > 0 && can_shoot && !is_reloading:
		shoot()
	elif Input.is_action_pressed("attack") && actual_clip == 0 && can_shoot && !is_reloading || Input.is_action_pressed("reload") && can_shoot && actual_clip != max_ammo && !is_reloading:
		reload()

func shoot() -> void:
	if !gui_pointer:
		return
	can_shoot = false
	_create_bullet()

func _create_bullet() -> void:
	var bullets: Array[Bullet] = []
	
	for i in bullet_count:
		var new_bullet = OBJ_BULLET.instantiate() as Bullet
		new_bullet.set_damage(damage)
		new_bullet.global_position = shoot_point.global_position
		var arc_rad = deg_to_rad(arc)
		if bullet_count == 1:
			new_bullet.rotation = shoot_point.global_rotation
		else:
			var increment = arc_rad / (bullet_count - 1)
			new_bullet.global_rotation = (
				shoot_point.global_rotation + increment * i -
				arc_rad / 2
			)
		get_tree().root.add_child(new_bullet)
		bullets.append(new_bullet)
	for i in bullets:
		i._activate_item()
		actual_clip -= 1
		gui_pointer.gun_shoot(self)
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true

func reload() -> void:
	if !gui_pointer:
		return
	can_shoot = false
	is_reloading = true
	var mod: float = max_ammo - actual_clip
	var necessary_time: float 
	
	if mod == max_ammo:
		circular_progress_bar_component.set_loading_time(reload_time)
	else:
		necessary_time = bullet_reload_time * mod
		circular_progress_bar_component.set_loading_time(necessary_time)
	
	circular_progress_bar_component._set_texture_scale(Vector2(0.1,0.1))
	circular_progress_bar_component.loading()
	gui_pointer.gun_reload(self)
	await circular_progress_bar_component.animation_end
	can_shoot = true
	is_reloading = false

func _get_texture() -> TextureRect:
	return null

func apply_upgrade() -> void:
	pass

func get_actual_clip() -> int:
	return actual_clip

func _drop_item(_throw_direction: Vector2) -> InteractableItem:
	var stats: ItemStats = ItemStats.new()
	var my_stats: Array = [damage, actual_clip, max_ammo, shoot_delay]
	stats.set_item_stats(my_stats)
	
	var interact_item: InteractableItem
	
	return null
