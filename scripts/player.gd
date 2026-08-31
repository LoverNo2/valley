extends CharacterBody2D

const SPEED = 300.0
var direction = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()
