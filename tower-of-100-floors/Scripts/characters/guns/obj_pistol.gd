extends CharacterBody2D
class_name Pistol

@export_category("Configurações")
@export var damage: float = 10.0
@export var reload_time: float = 2.5
@export var rich_text_label: RichTextLabel

@onready var is_player_entered: bool = false
@onready var is_equiped: bool = false
@onready var player_pointer: Player
@onready var marker_2d: Marker2D = $Marker2D

const RICH_TEXT: String = "[shake] Press [F] to equip [/shake]"

func _ready() -> void:
	rich_text_label.hide()

func _process(delta: float) -> void:
	if player_pointer && !is_equiped && is_player_entered && Input.is_action_just_pressed("interact"):
		equip_gun()

func equip_gun() -> void:
	pass
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entrou")
		player_pointer = body as Player
		rich_text_label.global_position = marker_2d.global_position
		rich_text_label.global_position.x -= 45.0
		
		rich_text_label.show()
		is_player_entered = true
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player saiu")
		rich_text_label.hide()
		is_player_entered = false
