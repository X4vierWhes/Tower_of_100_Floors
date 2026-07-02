extends Node

const BOMB_SCENE := preload("uid://ccng2qebsn0c4")
const GHOST_MATERIAL := preload("uid://b3pnfx5v82x1j")
const DAMAGE_MATERIAL: = preload("uid://dfotrmxng7wiy")
const COIN_SCENE:= preload("uid://0v0oy5g30imf")
const FONT_LABEL := preload("uid://bsp438tl0ck0e")
const MAGIC_SCENE:= preload("uid://krmikpan11be")
const PLAYER_SCENE: String = "uid://ckisamdxmuhow"

const EQUIPMENTS_DIR: String = "res://src/core/itens/equipment/obj_"

var is_paused: bool = false

var global_camera: GlobalCamera = null

var actual_room_id: String = "null"

var item_component: ItensControlComponent = null
