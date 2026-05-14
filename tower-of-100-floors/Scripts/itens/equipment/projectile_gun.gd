extends GunBase
class_name ProjectileGun

@export_category("Projectile Gun Parameters")
@export_subgroup("Gun imports")
@export var OBJ_BULLET: PackedScene
@export var shoot_point: Marker2D
@export var circular_progress_bar_component: CircularProgressBar
@export var sprite: Sprite2D
@export var texture_scale: Vector2 = Vector2.ONE
@export_subgroup("Gun stats")
@export var damage: int = 10
@export var max_ammo: int = 22
@export var actual_clip: int = 22
@export var bullet_count: int = 1
@export_range(0.1, 2.0) var shoot_delay: float = 0.6
@export_range(0, 360) var arc: float = 0
@export_range(0.8, 3.0) var reload_time: float = 0.8
@export_range(200, 1200) var bullet_range: float = 400

func shoot(_force: float) -> void:
	if actual_clip > 0 && can_shoot && !is_reloading:
		can_shoot = false
		_create_bullet(_force)

func _create_bullet(_force: float) -> void:
	var bullets: Array[Bullet] = []
	
	for i in bullet_count:
		var new_bullet = OBJ_BULLET.instantiate() as Bullet
		new_bullet.set_damage(damage)
		new_bullet.set_force(_force)
		new_bullet.range_distance = bullet_range
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
		update_gun.emit("shoot")
	await get_tree().create_timer(shoot_delay).timeout
	can_shoot = true

func reload() -> void:
	if is_reloading || actual_clip == max_ammo:
		return
	
	can_shoot = false
	is_reloading = true
	
	circular_progress_bar_component.set_loading_time(reload_time)
	circular_progress_bar_component._set_texture_scale(Vector2(0.1,0.1))
	circular_progress_bar_component.loading()
	
	update_gun.emit("reload")
	await circular_progress_bar_component.animation_end
	
	actual_clip = max_ammo
	can_shoot = true
	is_reloading = false

func get_drop_item() -> InteractableItem:
	update_gun.emit("drop")
	stats = ItemStats.new()
	var my_stats: Array = [damage, actual_clip, max_ammo, shoot_delay]
	stats.set_item_stats(my_stats)
	var dir: String = DIR_DROP_ITEM + drop_item_name + ".tscn"
	var interact_item = load(dir)
	
	var item = interact_item.instantiate() as InteractableItem
	item._set_drop_item_stats(stats)
	return item

func _update_item_actual_stats() -> void:
	if !stats:
		return
	# var my_stats: Array = [damage, actual_clip, max_ammo, shoot_delay]
	damage = stats.get_at(0)
	actual_clip = stats.get_at(1)
	max_ammo = stats.get_at(2)
	shoot_delay = stats.get_at(3)
	return

func _apply_upgrade(_up: String) -> void:
	# Esperado uma string tipo "Damage:+:50"
	
	pass

func _get_texture() -> Sprite2D:
	var texture: Sprite2D = sprite.duplicate()
	texture.scale = texture_scale
	return texture

func apply_upgrade() -> void:
	pass

func get_actual_clip() -> int:
	return actual_clip
