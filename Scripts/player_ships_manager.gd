extends Node

const PLAYER = preload("res://Scenes/player_ship.tscn")
const SHIPS_NUM := 2
var spawn_point : Vector2

func _ready() -> void:
	spawn()

# BUG - spawned ships have no initial velocity (probably not instantiated when rts node checks for units)

func spawn():
	for ship in range(SHIPS_NUM):
		var new_ship = PLAYER.instantiate()
		new_ship.global_position = Vector2(randi_range(-2000, 0), randi_range(-2000, 0))
		get_tree().current_scene.add_child.call_deferred(new_ship)
