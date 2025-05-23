extends CharacterBody2D

var speed = 100
var acceleration = 1000
var rotate_velocity = 0
var angle
var target_direction
var selected = false

@onready var label = $Label

func _ready():
	add_to_group("unit")

func _process(delta: float) -> void:
	label.visible = selected

func _physics_process(delta):
	if velocity.length() > speed:
		velocity = velocity.normalized() * speed 
