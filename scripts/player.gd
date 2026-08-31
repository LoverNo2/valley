extends CharacterBody2D

const SPEED = 300.0
var direction = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	_get_input()
	velocity = direction * SPEED
	animation()
	move_and_slide()


func _get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")


func animation() -> void:
	if direction != Vector2.ZERO:
		var dir: Vector2 = Vector2(round(direction.x), round(direction.y))
		$AnimationTree.set("parameters/StateMachine/walk/blend_position", dir)
	else:
		var dir: Vector2 = Vector2(round(direction.x), round(direction.y))
		$AnimationTree.set("parameters/StateMachine/idle/blend_position", dir)
