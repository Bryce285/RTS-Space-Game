extends State
class_name EnemyShipMove

@export var enemy : CharacterBody2D
@export var acceleration := 100.0
@export var max_speed := 300.0

var direction_offset
var angle = randf() * TAU

func physics_update(delta : float):
	direction_offset = enemy.global_position - Main.formation_center
	var target_direction = (Vector2.RIGHT.rotated(angle) + direction_offset) - enemy.global_position
	
	if target_direction.length() > 0.1:
		var thrust_direction = target_direction.normalized()
		enemy.velocity += thrust_direction * acceleration * delta
	
	if enemy.velocity.length() > max_speed:
		enemy.velocity = enemy.velocity.normalized() * max_speed
	
	enemy.move_and_slide()
