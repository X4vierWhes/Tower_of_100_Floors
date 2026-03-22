extends CharacterInterface
class_name Wizard

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var navigation_timer: Timer = $navigation_timer
@onready var player_pointer: Player = null
@onready var state: String = "idle"
@onready var can_take_damage: bool = true
@onready var magic_point: Marker2D = $magic_point
@onready var range_area: Area2D = $range_area
@onready var attack_area: Area2D = $attack_area

var can_attack: bool = true
var searching_goal: Vector2 = Vector2(10, 5)
var tween: Tween
const MAGIC_SCENE: String = "uid://krmikpan11be"

func _ready() -> void:
	anim.play(state)
	enemie_control()

func _process(_delta: float) -> void:
	anim.play(state)
	if state == "run":
		_chase_player()
	

func _chase_player() -> void:
	if !navigation_agent_2d.is_target_reached():
		
		var next_path_pos = navigation_agent_2d.get_next_path_position()
		
		var direction = global_position.direction_to(next_path_pos)
		
		velocity = direction * speed
		move_and_slide()
		
		anim.flip_h = velocity.x < 0

func _take_damage(damage: int) -> void:
	if !can_take_damage: return
	
	if tween && tween.is_running():
		tween.kill()
	
	can_take_damage = false
	tween = create_tween()
	_create_damage_label()
	
	var shader_setter = func(value: float):
		anim.material.set_shader_parameter("hit_effect", value)
	
	tween.tween_method(shader_setter, 0.55, 0.0, 0.2)
	
	await tween.finished
	_calc_damage(damage)

func _calc_damage(damage: int) -> void:
	actual_health -= damage
	if actual_health > 0:
		can_take_damage = true
	else:
		set_process(false)
		emit_signal("is_death")

func _shoot() -> void:
	if !player_pointer or actual_health <= 0:
		return
	state = "attack"
	
	var magic_scene = preload(MAGIC_SCENE)
	var magic_projectile = magic_scene.instantiate() as Magic
	
	get_parent().add_child(magic_projectile)
	
	magic_projectile.global_position = magic_point.global_position
	var dir_to_player = magic_point.global_position.direction_to(player_pointer.global_position)
	magic_projectile.launch(dir_to_player)
	
	magic_projectile._throw_item(1)
	await get_tree().create_timer(.8).timeout 
	
	if actual_health > 0:
		state = "run"
	
	await  get_tree().create_timer(1.4).timeout
	_shoot()

func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entrou no range")
		player_pointer = body as Player
		state = "run"
		navigation_timer.start()
		range_area.monitoring = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and player_pointer and state != "attack":
		attack_area.monitoring = false
		_shoot()

func _on_navigation_timer_timeout() -> void:
	if player_pointer:
		if navigation_agent_2d.target_position != player_pointer.global_position:
			navigation_agent_2d.target_position = player_pointer.global_position
	navigation_timer.start()
