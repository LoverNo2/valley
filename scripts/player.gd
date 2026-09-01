extends CharacterBody2D

const SPEED = 100
var direction = Vector2.ZERO
var is_using_tool = false

enum Tools {
	HOE,
	AXE,
	WATER,
}

var tool_map = { Tools.HOE: "hoe", Tools.AXE: "axe", Tools.WATER: "water" }

var current_tool = Tools.HOE

var walk_state_machine: AnimationNodeStateMachinePlayback
var tool_state_machine: AnimationNodeStateMachinePlayback


func _ready() -> void:
	walk_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
	tool_state_machine = $AnimationTree.get("parameters/ToolStateMachine/playback")


func _physics_process(_delta: float) -> void:
	if not is_using_tool:
		_get_input()
	velocity = direction * SPEED * int(!is_using_tool)
	animation()
	move_and_slide()


func _get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("tool_pre") || Input.is_action_just_pressed("tool_next"):
		var tool_delta = 1 if Input.is_action_just_pressed("tool_next") else -1
		current_tool = posmod(current_tool + tool_delta, Tools.size()) as Tools

	if Input.is_action_just_pressed('action'):
		is_using_tool = true
		tool_state_machine.travel(tool_map[current_tool])
		$AnimationTree.set('parameters/OneShot/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


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
