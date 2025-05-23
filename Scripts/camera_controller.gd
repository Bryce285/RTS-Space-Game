extends Camera2D

@export var zoom_speed : float = 10.0

var zoom_target : Vector2

var drag_start_mouse_pos = Vector2.ZERO
var drag_start_camera_pos = Vector2.ZERO
var is_dragging : bool = false


func _ready() -> void:
	zoom_target = zoom

func _process(delta: float) -> void:
	zoom_control(delta)
	simple_pan(delta)
	click_and_drag()

func zoom_control(delta):
	if Input.is_action_just_pressed("camera_zoom_in") && zoom_target < Vector2(2, 2):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("camera_zoom_out") && zoom_target > Vector2(0.15, 0.15):
		zoom_target *= 0.9
	
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)

func simple_pan(delta):
	var move_amount = Vector2.ZERO
	
	if Input.is_action_pressed("camera_move_right"):
		move_amount.x += 1
	if Input.is_action_pressed("camera_move_left"):
		move_amount.x -= 1
	if Input.is_action_pressed("camera_move_up"):
		move_amount.y -= 1
	if Input.is_action_pressed("camera_move_down"):
		move_amount.y += 1
	
	move_amount = move_amount.normalized()
	position += move_amount * delta * 1000 * (1/zoom.x)

func click_and_drag():
	if !is_dragging and Input.is_action_just_pressed("camera_pan"):
		drag_start_mouse_pos = get_viewport().get_mouse_position()
		drag_start_camera_pos = position
		is_dragging = true
	
	if is_dragging and Input.is_action_just_released("camera_pan"):
		is_dragging = false
	
	if is_dragging:
		var move_vector = get_viewport().get_mouse_position() - drag_start_mouse_pos
		position = drag_start_camera_pos - move_vector * 1/zoom.x
