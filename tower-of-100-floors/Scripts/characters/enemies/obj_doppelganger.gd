extends EnemyInterface
class_name Doppelganger

func _ready() -> void:
	enemie_control()

func _physics_process(delta: float) -> void:
	if Globals.is_paused:
		return
	pass
