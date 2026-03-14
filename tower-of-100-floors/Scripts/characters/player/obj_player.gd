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
var dash_cooldown: float = 1.4
var dash_duration: float = 0.4

func _ready() -> void:
	var parent = get_parent() as Game
	if parent:
		print("Peguei")
		gui_pointer = parent._get_gui()
		update_gui()
	

func _process(delta: float) -> void:
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
	

func dash() -> void:
	can_dash = false
	is_dashing = true
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func _equip(item: Item) -> void:
	gun = item as Pistol
	gun.global_position.x += 50.0
	
	guns_pivot.add_child(gun)
	
	if gui_pointer:
		print("Passei ponteiros")
		gun._set_pointers(self, gui_pointer)
	gun.set_process(true)
	if gun: 
		print("Atualizar gun in player")
		gui_pointer.update_gun(gun)

func _get_stats() -> Vector3:
	return Vector3(health, coins, bombs)

func update_gui() -> void:
	if gui_pointer:
		print("Atualizei")
		gui_pointer.update_player(self)
	
