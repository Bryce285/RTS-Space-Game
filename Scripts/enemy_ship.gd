extends CharacterBody2D
class_name EnemyShip

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	move_and_slide()
