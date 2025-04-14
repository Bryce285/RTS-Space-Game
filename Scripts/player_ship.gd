extends CharacterBody2D

var speed = 300
var click_position = Vector2.ZERO
var rotation_speed = 5.0 

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var label = $Label
var selected = false

func _ready():
	click_position = position
	
	add_to_group("unit")

func _process(delta: float) -> void:
	label.visible = selected

func _physics_process(delta):
	if not navigation_agent_2d.target_position: return
	
	var direction = (navigation_agent_2d.get_next_path_position() - global_position).normalized()
	
	if direction: velocity = direction * speed
	else: velocity = Vector2.ZERO
	
	move_and_slide()

func set_target_position(position):
	navigation_agent_2d.target_position = position

func _on_navigation_agent_2d_target_reached() -> void:
	navigation_agent_2d.target_position = Vector2.ZERO
