extends CharacterBody2D
class_name CharacterInterface

@export_category("Parameters")
@export var speed: float = 300.0
@export var max_health: int = 8
@export var dash_force: float = 1.5
@export var heal: int = 0
@export var coins: int = 0
@export var bombs: int = 0
@export var god_mode: bool = false

@onready var hurt_phrases: Array[String] = ["it hurts!", "oh, no!", "dammit!"]
@onready var actual_health = max_health

var death: bool = false


func _ready() -> void:
	if get_parent() && get_parent() is EnemiesControl:
		var parent = get_parent() as EnemiesControl
		parent._append_enemie(self)
	

func _take_damage(damage: int) -> void:
	pass

func _create_damage_label(damage_amount: int) -> void:
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
	
	get_parent().add_child(label)
	
	label.global_position = global_position + Vector2(-50, -40)
	
	var tween = create_tween()
	tween.tween_property(label, "global_position:y", label.global_position.y - 50, 0.6)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6)
	tween.tween_callback(label.queue_free)
