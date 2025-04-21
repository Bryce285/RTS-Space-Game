extends Node

const ENEMY = preload("res://Scenes/enemy_ship.tscn")
const SHIPS_NUM = 3
var formation = []
var formation_move_target

func _ready() -> void:
	spawn()
	calculate_centroid()

func spawn():
	for ship in range(SHIPS_NUM):
		var new_enemy = ENEMY.instantiate()
		new_enemy.global_position = Vector2(randi_range(-1000, 1000), randi_range(-1000, 1000))
		get_tree().current_scene.add_child.call_deferred(new_enemy)
		formation.append(new_enemy)

func calculate_centroid():
	for ship in formation:
		Main.formation_center += ship.global_position
	Main.formation_center /= formation.size()
