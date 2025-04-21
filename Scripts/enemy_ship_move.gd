extends State
class_name EnemyShipMove

@export var enemy : CharacterBody2D
@export var speed := 300.0
var objective : Area2D
var direction_offset

func enter():
	objective = get_tree().get_first_node_in_group("objective")

func physics_update(delta : float):
	direction_offset = enemy.global_position - Main.formation_center
	var direction = (objective.global_position + direction_offset) - enemy.global_position
	
	if enemy.global_position.distance_to(Main.objective_position) < 1000:
		Transitioned.emit(self, "EnemyShipHold")
	elif enemy.global_position.distance_to(Main.objective_position) > 25:
		enemy.velocity = direction.normalized() * speed
	else:
		enemy.velocity = Vector2()
