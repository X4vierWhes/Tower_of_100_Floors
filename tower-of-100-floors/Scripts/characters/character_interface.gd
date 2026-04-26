extends CharacterBody2D
class_name CharacterInterface

@export_category("Base Stats")
@export var speed: float = 300.0
@export var max_health: int = 8
@export var heal: int = 0
@export var coins: int = 0
@export var bombs: int = 0
@export var god_mode: bool = false
@export var hurt_phrases: Array[String] = ["it hurts!", "oh, no!", "dammit!"]

@export var anim:AnimatedSprite2D

@warning_ignore("unused_signal")signal is_death

var tween: Tween
var death: bool = false
var can_take_damage: bool = true
var actual_health: int = max_health

func _take_damage(_damage: int) -> void:
	pass

func _heal(_amount: int) -> void:
	pass

func _move(_direction:Vector2) -> void:
	pass #TODO

func _create_damage_label() -> void:
	var label = RichTextLabel.new()
	var font_label = load("res://Resources/font/Daydream DEMO.otf")
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_size_override("normal_font_size", 8)
	label.add_theme_font_override("normal_font", font_label)
	hurt_phrases.shuffle()
	label.bbcode_enabled = true
	label.text = "[center][color=RED]" + hurt_phrases.get(0) + "[/color][/center]" 
	label.custom_minimum_size = Vector2(100, 50)
	
	add_child(label)
	
	label.global_position = global_position + Vector2(-50, -40)
	
	var damage_tween: Tween = create_tween()
	
	damage_tween.tween_property(label, "global_position:y", label.global_position.y - 50, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	damage_tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6)
	
	damage_tween.tween_callback(label.queue_free)
