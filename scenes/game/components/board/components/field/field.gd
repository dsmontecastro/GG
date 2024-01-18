extends TileMap
class_name Field

# TileSet Info --------------------------------------------------------------- #

@onready var SET: TileSet = tile_set
@onready var CELL = SET.tile_size
@onready var HALF = CELL / 2

# Array Creation & Resetting ------------------------------------------------- #

const SPECS = Vector2i(9, 8)
var ARRAY = ROOT.make_arr(SPECS.x, SPECS.y)

func _reset():
	reset_map()
	reset_arr()

func reset_map():
	for node in get_children():
		remove_child(node)
		node.queue_free()

func reset_arr():
	for r in range(SPECS.x):
		for c in range(SPECS.y):
			ARRAY[r][c] = null


# Empty Checkers ------------------------------------------------------------- #

func cell_empty(x: int, y: int) -> bool: return ARRAY[y][x] == null

func is_clear(arr: Array) -> bool:
	for row in ARRAY:
		if !row.all(null): return false
	return true


# Grid-to-Position (Transposed) ---------------------------------------------- #

func get_grid_idx(pos: Vector2): return self.local_to_map(pos)

func get_grid_pos(x: int, y: int) -> Vector2:	
	var pos = self.map_to_local(Vector2(y, x))
	return pos + HALF


# :DEBUGGING: ---------------------------------------------------------------- #

func print_grid():
	for r in range(SPECS.x):
		var row = ""
		for c in range(SPECS.y):
			var type: int = 0
			var unit: Unit = ARRAY[r][c]
			if unit != null: type = unit.TYPE
			row += ("%0+3d " % type)
		print(row)
	print()
