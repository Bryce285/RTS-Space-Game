extends Node2D

@onready var selection_area = $"../SelectionArea"
@onready var collision_shape_2d = $"../SelectionArea/CollisionShape2D"
@onready var long_left_click_timer = $"../LongLeftClickTimer"

var selection_start_point = Vector2.ZERO
var left_mouse_pressed = false
var left_mouse_released = false
var left_mouse_long_pressed = false
var selected_units := []
var initial_speed = 100.0

func _ready() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		selected_units.append(unit)
		unit.selected = true
	_set_move_target()

func _input(event: InputEvent) -> void:
	left_mouse_pressed = event is InputEventMouseButton && event.button_index == 1 && event.is_pressed()
	left_mouse_released = event is InputEventMouseButton && event.button_index == 1 && not event.is_pressed()
	
	if left_mouse_pressed:
		long_left_click_timer.start()
	elif left_mouse_released:
		left_mouse_long_pressed = false
		long_left_click_timer.stop()

func _process(delta: float) -> void:
	if left_mouse_long_pressed && selection_start_point == Vector2.ZERO:
		selection_start_point = get_global_mouse_position()
	elif left_mouse_released && selection_start_point != Vector2.ZERO:
		_select_units()
		selection_start_point = Vector2.ZERO
	
	queue_redraw()

func _physics_process(delta: float) -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		if unit in selected_units:
			if Input.is_action_pressed("rotate_left"):
				unit.rotate_velocity -= 1 * delta
			if Input.is_action_pressed("rotate_right"):
				unit.rotate_velocity += 1 * delta
		
			if Input.is_action_pressed("thrust_increase"):
				unit.velocity += Vector2.RIGHT.rotated(unit.rotation) * unit.acceleration * delta
		
		unit.rotation += unit.rotate_velocity * delta
		unit.move_and_slide()

func _draw() -> void:
	if selection_start_point == Vector2.ZERO: return
	
	var mouse_position = get_global_mouse_position()
	var start_x = selection_start_point.x
	var start_y = selection_start_point.y
	var end_x = mouse_position.x
	var end_y = mouse_position.y
	
	var line_width = 8.0
	var line_color = Color.WHITE
	
	draw_line(Vector2(start_x, start_y), Vector2(end_x, start_y), line_color, line_width)
	draw_line(Vector2(start_x, start_y), Vector2(start_x, end_y), line_color, line_width)
	draw_line(Vector2(end_x, start_y), Vector2(end_x, end_y), line_color, line_width)
	draw_line(Vector2(start_x, end_y), Vector2(end_x, end_y), line_color, line_width)

func _select_units():
	selected_units.clear()
	var size = abs(get_global_mouse_position() - selection_start_point)
	var area_position = _get_rect_start_position()
	
	selection_area.global_position = area_position
	collision_shape_2d.global_position = area_position + size / 2
	collision_shape_2d.shape.size = size
	
	await get_tree().create_timer(0.04).timeout
	
	var units = get_tree().get_nodes_in_group("unit")
	
	for body in selection_area.get_overlapping_bodies():
		if body in get_tree().get_nodes_in_group("unit"):
			body.selected = true
			selected_units.append(body)
			units.erase(body)
	for body in units:
		body.selected = false

func _get_rect_start_position():
	var new_position = Vector2()
	var mouse_position = get_global_mouse_position()
	
	if selection_start_point.x < mouse_position.x:
		new_position.x = selection_start_point.x
	else: new_position.x = mouse_position.x
	
	if selection_start_point.y < mouse_position.y:
		new_position.y = selection_start_point.y
	else: new_position.y = mouse_position.y
	
	return new_position

func _set_move_target():
	for unit in get_tree().get_nodes_in_group("unit"):
		if unit.selected:
			selected_units.append(unit)
	
	if selected_units.is_empty():
		return
	
	var center := Vector2.ZERO
	for unit in selected_units:
		center += unit.global_position
	center /= selected_units.size()
	
	var random_angle = randf() * TAU
	
	# Players initial movement direction is based on their position in the scene. Randomize their
	# position to randomize their initial direction.
	
	for unit in selected_units:
		var offset = unit.global_position - center
		unit.angle = random_angle
		var direction = (Vector2.RIGHT.rotated(unit.angle) + offset) - unit.global_position
		unit.velocity = direction.normalized() * initial_speed
		unit.rotation = unit.velocity.angle()

func _on_long_left_click_timer_timeout() -> void:
	left_mouse_long_pressed = true
