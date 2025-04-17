extends State
class_name EnemyShipMove

@export var enemy : CharacterBody2D
@export var speed := 300.0
var objective : Area2D

func enter():
	objective = get_tree().get_first_node_in_group("objective")

func physics_update(delta : float):
	var direction = objective.global_position - enemy.global_position
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * speed
	else:
		enemy.velocity = Vector2()
	
	if direction.length() < 50:
		Transitioned.emit(self, "EnemyShipHold")
