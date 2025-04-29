extends State
class_name EnemyShipHold

# This script is not necessary with the current movement mechanics but
# I'm keeping it for now in case I want to add another state later
@export var enemy: CharacterBody2D
@export var speed := 300.0

var objective : Area2D

var direction_offset
var target_position : Vector2
var hold_time : float
var move_target
var direction

# change this so that the holding pattern is predictable instead of
# generated differently for each ship
func generate_holding_pattern():
	target_position = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
	hold_time = randf_range(5, 10)
	direction_offset = enemy.global_position - Main.formation_center
	move_target = Main.objective_position.normalized() + target_position
	direction = (move_target + direction_offset) - enemy.global_position
	print(target_position)

func enter():
	objective = get_tree().get_first_node_in_group("objective")
	generate_holding_pattern()

func physics_update(delta: float):
	if hold_time > 0:
		hold_time -= delta
	else:
		print("randomize")
		generate_holding_pattern()
	
	if enemy:
		enemy.velocity = direction.normalized() * speed
	
	# BUG - when transitioning back to move state, enemies will not actually
	# move towards objective position
	if enemy.global_position.distance_to(Main.objective_position) > 10000:
		Transitioned.emit(self, "EnemyShipMove")
