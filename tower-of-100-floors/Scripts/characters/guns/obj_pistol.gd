extends CharacterBody2D
class_name Pistol

@export_category("Configurações")
@export var damage: float = 10.0
@export var reload_time: float = 2.5
@onready var is_equiped: bool = false
@onready var rich_text_label: RichTextLabel = $CanvasLayer/RichTextLabel


func _ready() -> void:
	rich_text_label.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entrou")
		rich_text_label.visible = true
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player saiu")
		rich_text_label.visible = false
