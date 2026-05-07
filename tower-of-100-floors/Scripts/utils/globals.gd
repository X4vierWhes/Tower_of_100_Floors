extends Node

const BOMB_SCENE = preload("res://Scenes/itens/usable_itens/obj_bomb.tscn")
const GHOST_MATERIAL = preload("res://shaders/retro_vhs_glitch.gdshader")
const DAMAGE_MATERIAL = preload("res://shaders/flash_and_random_shake.gdshader")
const PLAYER_SCENE: String = "uid://ckisamdxmuhow"

var is_paused: bool = false

var global_camera: Camera2D = null

var actual_room_id: String = "null"

var item_component: ItensControlComponent = null
