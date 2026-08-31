extends CharacterBody2D

const SPEED = 100
var direction = Vector2.ZERO


enum Tools {
	HOE,
	AXE,
	WATER
}
var current_tool = Tools.HOE

var walk_state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	walk_state_machine = $AnimationTree.get("parameters/StateMachine/playback")

func _physics_process(_delta: float) -> void:
	_get_input()
	velocity = direction * SPEED
	animation()
	move_and_slide()


func _get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("tool_pre") || Input.is_action_just_pressed("tool_next"):
		var tool_delta = 1 if Input.is_action_just_pressed("tool_next") else -1
		current_tool = posmod(current_tool + tool_delta, Tools.size()) as Tools


func animation() -> void:
	if direction:
		var direction2 = Vector2i(roundi(direction.x), roundi(direction.y))
		walk_state_machine.travel("walk")
		$AnimationTree.set("parameters/StateMachine/walk/blend_position", direction2)
		$AnimationTree.set("parameters/StateMachine/idle/blend_position", direction2)
	else:
		walk_state_machine.travel("idle")
