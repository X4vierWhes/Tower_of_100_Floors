extends EnemyInterface
class_name Bug

var player_pointer:Player = null
@onready var animation_player = $AnimationPlayer

func _ready():
	enemie_control()

func _physics_process(delta: float) -> void:
	if Globals.is_paused:
		return
	if !navigation_agent.is_target_reached() and !animation_player.is_playing():
		var next_path_pos = navigation_agent.get_next_path_position()
		var direction = global_position.direction_to(next_path_pos)
		velocity = direction * speed * delta
		move_and_slide()
	elif (player_pointer):
		animation_player.play("jump")

func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pointer = body as Player
		_set_new_target_direction()
		navigation_timer.paused = false
		navigation_timer.start()

func _on_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_pointer = null
		navigation_timer.paused = true

func _set_new_target_direction() -> void:
	if player_pointer:
		navigation_agent.target_position = player_pointer.global_position
