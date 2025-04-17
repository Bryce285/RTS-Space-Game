extends State
class_name EnemyShipHold

@export var enemy: CharacterBody2D
@export var speed := 300.0

var move_direction : Vector2
var move_time : float
var objective : Area2D

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	move_time = randf_range(1, 3)

func enter():
	objective = get_tree().get_first_node_in_group("objective")
	randomize_wander()

func update(delta: float):
	if move_time > 0:
		move_time -= delta
	else:
		randomize_wander()

func physics_update(delta: float):
	if enemy:
		enemy.velocity = move_direction * speed
	
	var direction = objective.global_position - enemy.global_position
	
	# increase the distance to emit when implementing better movement
	if direction.length > 1000:
		Transitioned.emit(self, "EnemyShipMove")
