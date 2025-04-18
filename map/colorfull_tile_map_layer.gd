extends TileMapLayer

class_name ColorfullTileMapLayer

var colored_cells: Dictionary[Vector2i, Color] = {}

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return colored_cells.has(coords)
	
	
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.modulate = colored_cells[coords]


func colorize(pos: Vector2i, color: Color) -> void:
	if color == Color.TRANSPARENT:
		colored_cells.erase(pos)
	else:
		colored_cells[pos] = color
