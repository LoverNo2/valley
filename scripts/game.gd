extends Node2D

var player: CharacterBody2D


func _ready() -> void:
	player = $Objects/Player


func _on_player_tool_used(tool: int, pos: Vector2) -> void:
	var tile_pos = Vector2i(int(pos.x / 16), int(pos.y / 16))
	if tool == player.Tools.HOE:
		var cell = $Layers/GlassLayer.get_cell_tile_data(tile_pos)
		if cell and cell.get_custom_data('usable'):
			$Layers/RoadLayer.set_cells_terrain_connect([tile_pos], 0, 0)
