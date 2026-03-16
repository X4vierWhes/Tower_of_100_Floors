extends CharacterInterface
class_name Player

@onready var anim_player: AnimatedSprite2D = $animPlayer
@onready var father: Game = get_parent() as Game
@onready var guns_pivot: Marker2D = $guns_pivot
@onready var gui_pointer: GUI = null
@onready var gun: Pistol = null

var has_gun: bool = false
var can_dash: bool = true
var is_dashing: bool = false
var can_take_damage: bool = true
var dash_cooldown: float = 1.4
var dash_duration: float = 0.4

func _ready() -> void:
	var parent = get_parent() as Game
	if parent:
		gui_pointer = parent._get_gui()
		update_gui()
	

func _process(_delta: float) -> void:
	guns_pivot_update()
	
	if actual_health < 0:
		death = true;
		print("Player morreu")
	
	if is_dashing:
		dashing_effect()
	
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
	

func guns_pivot_update() -> void:
	guns_pivot.look_at(get_global_mouse_position())
	guns_pivot.scale.y = -1 if guns_pivot.global_rotation_degrees > 90 || guns_pivot.global_rotation_degrees < -90 else 1
	

func dash() -> void:
	can_dash = false
	is_dashing = true
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func dashing_effect() -> void:
	pass

func _equip(item: Item) -> void:
	gun = item as Pistol
	gun.global_position.x += 50.0
	
	guns_pivot.add_child(gun)
	
	if gui_pointer:
		gun._set_pointers(self, gui_pointer)
	gun.set_process(true)
	if gun: 
		gui_pointer.update_gun(gun)
	

func _take_damage(damage: int) -> void:
	if !god_mode || can_take_damage || actual_health < 0:
		pass
	
	can_take_damage = false
	
	gui_pointer.player_take_damage(damage, self)
	_create_damage_label(damage)
	
	await get_tree().create_timer(0.7).timeout
	can_take_damage = true


func _get_stats() -> Vector3:
	return Vector3(actual_health, coins, bombs)

func update_gui() -> void:
	if gui_pointer:
		gui_pointer.update_player(self)
	

func _get_gun() -> Item:
	return gun
