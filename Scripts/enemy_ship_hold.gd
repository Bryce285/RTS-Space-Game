extends State
class_name EnemyShipHold

@export var enemy: CharacterBody2D
@export var speed := 300.0
@export var holding_pattern_size := 500.0 # increase size of holding pattern later

var holding_pattern_center : Vector2
var holding_pattern_corners = []
var current_move_target_index = 0

var move_time : float
var objective : Area2D

func generate_holding_pattern():
	holding_pattern_center = objective.global_position
	var half = holding_pattern_size / 2
	holding_pattern_corners = [
		holding_pattern_center + Vector2(-half, -half),
		holding_pattern_center + Vector2(half, -half),
		holding_pattern_center + Vector2(half, half),
		holding_pattern_center + Vector2(-half, half)
	]

func enter():
	objective = get_tree().get_first_node_in_group("objective")
	generate_holding_pattern()

func physics_update(delta: float):
	var move_target = holding_pattern_corners[current_move_target_index]
	var direction = move_target - enemy.global_position
	
	if enemy:
		enemy.velocity = direction.normalized() * speed
	
	if direction.length() < 25:
		current_move_target_index = (current_move_target_index + 1) % holding_pattern_corners.size()
		return
	# increase the distance to emit when implementing better movement
	elif direction.length() > 1000:
		Transitioned.emit(self, "EnemyShipMove")
