extends CharacterInterface
class_name Player

var has_gun: bool = false

@onready var anim_player: AnimatedSprite2D = $animPlayer
@onready var father: Game = get_parent() as Game
@onready var guns_pivot: Marker2D = $guns_pivot
@onready var gui_pointer: GUI = null
@onready var gun: Pistol = null

func _ready() -> void:
	var parent = get_parent() as Game
	if parent:
		print("Peguei")
		gui_pointer = parent._get_gui()
		update_gui()
	

func _process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if velocity.x != 0:
		anim_player.play("run")
	else:
		anim_player.play("idle")
	
	if direction.x != 0:
		anim_player.flip_h = (direction.x < 0)
	

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
	
