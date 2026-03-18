extends CharacterInterface
class_name Bee

@onready var anim: AnimatedSprite2D = $anim
@onready var player_pointer: Player = null
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var navigation_timer: Timer = $navigation_timer
@onready var can_take_damage: bool = true

var searching_goal: Vector2 = Vector2(10, 5)
var tween: Tween
var state: String = "searching"

func _ready() -> void:
	if anim.material:
		anim.material = anim.material.duplicate()
	anim.play("idle")
	enemie_control()

func _process(_delta: float) -> void:
	if !player_pointer:
		velocity = searching_goal.normalized() * speed
		move_and_slide()
	else:
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


func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entrou na bee")
		player_pointer = body as Player
		navigation_timer.start()


func _on_range_area_body_exited(body: Node2D) -> void:
	pass


func _on_navigation_timer_timeout() -> void:
	if player_pointer:
		if navigation_agent_2d.target_position != player_pointer.global_position:
			navigation_agent_2d.target_position = player_pointer.global_position
	navigation_timer.start()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body._take_damage(1)
