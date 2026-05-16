extends InteractableItem
class_name InteractCoin

@export var coin_value:int = 1:
	set(i):
		if i<= 0: i= 1

func _interact() -> void: #sobrescrevendo
	player_pointer.coins += coin_value
	#animação de pegar moeda.play()
	queue_free()
	player_pointer.update_player.emit("use_item")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	player_pointer = body
	_interact()

func on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	player_pointer = body
	_interact()

func on_body_exited(_body: Node2D) -> void:
	return
