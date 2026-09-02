extends CharacterBody2D

const SPEED: float = 100.0
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.ZERO
var h_offset: int = 16
var c_offset: int = -14
var is_using_tool: bool = false

enum Tools {
	HOE,
	AXE,
	WATER,
}

var tool_map: Dictionary = { Tools.HOE: "hoe", Tools.AXE: "axe", Tools.WATER: "water" }

var current_tool: Tools = Tools.HOE

@onready var walk_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get(
	"parameters/MoveStateMachine/playback"
)
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get(
	"parameters/ToolStateMachine/playback"
)

signal tool_used(tool: Tools, pos: Vector2)


func _physics_process(_delta: float) -> void:
	if not is_using_tool:
		_get_input()
		if direction != Vector2.ZERO:
			last_direction = direction
	velocity = direction * SPEED * int(!is_using_tool)
	animation()
	move_and_slide()


func _get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("tool_pre") || Input.is_action_just_pressed("tool_next"):
		var tool_delta: int = 1 if Input.is_action_just_pressed("tool_next") else -1
		current_tool = posmod(current_tool + tool_delta, Tools.size()) as Tools

	if Input.is_action_just_pressed('action'):
		is_using_tool = true
		tool_state_machine.travel(tool_map[current_tool])
		$AnimationTree.set('parameters/OneShot/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		if current_tool == Tools.HOE:
			await $AnimationTree.animation_finished
			tool_used.emit(
				current_tool,
				global_position + last_direction * h_offset + Vector2(0, c_offset),
			)


func animation() -> void:
	if direction:
		var direction2 = Vector2i(roundi(direction.x), roundi(direction.y))
		walk_state_machine.travel("walk")
		$AnimationTree.set("parameters/MoveStateMachine/walk/blend_position", direction2)
		$AnimationTree.set("parameters/MoveStateMachine/idle/blend_position", direction2)
		for tool in tool_map.values():
			$AnimationTree.set("parameters/ToolStateMachine/%s/blend_position" % tool, direction2)
	else:
		walk_state_machine.travel("idle")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	var name_str := String(anim_name)
	if name_str.begins_with("axe") or name_str.begins_with("hoe") or name_str.begins_with("water"):
		is_using_tool = false


func sword_attack():
	print('sword_attack')
