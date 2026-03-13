extends Node2D
class_name GUI

@onready var itens_component: ItensComponent = $CanvasLayer/itens_component
@onready var heart_component: HeartComponent = $CanvasLayer/heart_component
@onready var gun_component: GunComponent = $CanvasLayer/gun_component
@onready var player_pivot: Player = null
