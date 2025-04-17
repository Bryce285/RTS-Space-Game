extends CharacterBody2D
class_name EnemyShip

func _physics_process(delta: float) -> void:
	move_and_slide()
