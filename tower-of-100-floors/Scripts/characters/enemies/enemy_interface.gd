extends CharacterInterface
class_name EnemyInterface

@onready var navigation_agent:NavigationAgent2D = %NavigationAgent2D
@onready var navigation_timer:Timer = %navigation_timer
@onready var attack_area:Area2D = %attack_area
@onready var impact_component: ImpactComponent = $impact_component

var attack_damage:int = 1
var state:String = "idle"

func _chase_player() -> void:
	pass

func _verify_collision() -> void:
	pass

func enemie_control() -> void:
	if get_parent() && get_parent() is EnemiesControl:
		var parent = get_parent() as EnemiesControl
		parent._append_enemie(self)
		randomize()
		coins = randi_range(0,5)

func _take_damage(damage: int) -> void:
	if !can_take_damage: 
		return
	
	can_take_damage = false
	var tween = create_tween()
	if impact_component:
		impact_component.play_impact(self)
	
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
		
		if Globals.COIN_SCENE:
			for i in range(coins):
				var coin:= Globals.COIN_SCENE.instantiate()
				var random_dir = Vector2.LEFT.rotated(randf_range(0, TAU))
				var ray = randf_range(10.0,  30.0)
				
				get_parent().add_child(coin)
				coin.global_position = global_position + (random_dir * ray)
		emit_signal("is_death")


func _do_damage(body:Node2D) -> void:
	if body.is_in_group("Player") and body is CharacterInterface:
		body._take_damage(attack_damage)
		var knock_dir: Vector2 = (body.global_position - global_position).normalized()
		body.apply_knockback(knock_dir, knockback_force, 0.12)
		attack_area.set_deferred("monitoring", false)
		await get_tree().create_timer(0.2).timeout
		attack_area.set_deferred("monitoring", true)
