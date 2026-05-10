extends CharacterBody2D
class_name CharacterInterface

@warning_ignore("unused_signal") signal is_death

@export_category("Base Stats")
@export var speed: float = 300.0
@export var max_health: int = 8: 
	set(value):
		max_health = value
		actual_health = value
	get():
		return max_health
@export var heal: int = 0
@export var coins: int = 0
@export var bombs: int = 0
@export var god_mode: bool = false
@export var hurt_phrases: Array[String] = ["it hurts!", "oh, no!", "dammit!"]
@export var anim:AnimatedSprite2D
@export var knockback_force: float = 100.0
@export var knockback_resistance: float = 100.0

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var is_knockbacking: bool = false
var death: bool = false
var can_take_damage: bool = true
var actual_health: int = max_health

func _take_damage(_damage: int) -> void:
	pass

func _heal(_amount: int) -> void:
	pass

func _move(_direction: Vector2 = Vector2.ZERO) -> void:
	pass

func _create_damage_label() -> void:
	var label = RichTextLabel.new()
	var font_label = load("res://Resources/font/Daydream DEMO.otf")
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_size_override("normal_font_size", 8)
	label.add_theme_font_override("normal_font", font_label)
	hurt_phrases.shuffle()
	label.bbcode_enabled = true
	label.text = "[center][color=#9ff4e5]" + hurt_phrases.get(0) + "[/color][/center]" 
	label.custom_minimum_size = Vector2(100, 50)
	
	add_child(label)
	
	label.global_position = global_position + Vector2(-50, -40)
	
	var damage_tween: Tween = create_tween()
	
	damage_tween.tween_property(label, "global_position:y", label.global_position.y - 50, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	damage_tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6)
	
	damage_tween.tween_callback(label.queue_free)

func apply_knockback(direction: Vector2, force: float, duration: float) -> void:
	if force < knockback_resistance:
		return
	knockback = direction * force
	knockback_timer = duration
	is_knockbacking = true

func _knockbacking_update(delta: float) -> void:
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	else:
		is_knockbacking = false
	
	move_and_slide()
