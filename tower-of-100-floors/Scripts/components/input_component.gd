extends Node2D
class_name InputComponent

var input_direction: Vector2 = Vector2.ZERO
var look_direction: Vector2 = Vector2.ZERO
var is_using_controller: bool = false

signal on_dash
signal on_throw
signal on_interact

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_using_controller = true
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		is_using_controller = false
	

func _process(_delta: float) -> void:
	if !is_using_controller:
		input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		look_direction = get_global_mouse_position()
	else:
		input_direction.x = Input.get_axis("move_left", "move_right")
		input_direction.y = Input.get_axis("move_up", "move_down")
		
		var joy_look: Vector2 = Vector2(
			Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), 
			Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))
		if joy_look.length() > 0.8:
			look_direction = joy_look
	
	if Input.is_action_just_pressed("dash"):
		on_dash.emit()
		
	if Input.is_action_just_pressed("throw"):
		on_throw.emit()
		
	if Input.is_action_just_pressed("interact"):
		on_interact.emit()
