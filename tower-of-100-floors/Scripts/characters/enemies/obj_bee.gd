extends EnemyInterface
class_name Bee

@onready var player_pointer: Player = null

var searching_goal: Vector2 = Vector2(10, 0)

func _ready() -> void:
	super._ready()
	if anim.material:
		anim.material = anim.material.duplicate()
	anim.play("idle")
	enemie_control()

func _process(_delta: float) -> void:
	if !player_pointer:
		velocity = searching_goal.normalized() * speed
		move_and_slide()
		_verify_collision()
	else:
		_chase_player()

func _chase_player() -> void:
	if !navigation_agent.is_target_reached():
		
		var next_path_pos = navigation_agent.get_next_path_position()
		
		var direction = global_position.direction_to(next_path_pos)
		
		velocity = direction * speed
		move_and_slide()
		
		anim.flip_h = velocity.x < 0

func _verify_collision() -> void:
	if get_slide_collision_count() == 0:
		return
	
	for i in get_slide_collision_count():
		var slide = get_slide_collision(i)
		if is_instance_valid(slide):
			print("Searching goal: " + str(searching_goal))
			searching_goal *= -1
			print("Searching goal * -1: " + str(searching_goal))
			return

func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pointer = body as Player
		navigation_timer.start()

func _on_navigation_timer_timeout() -> void:
	if player_pointer:
		if navigation_agent.target_position != player_pointer.global_position:
			navigation_agent.target_position = player_pointer.global_position
	navigation_timer.start()
