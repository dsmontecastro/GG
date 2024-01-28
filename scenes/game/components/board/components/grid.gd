extends TileMap
class_name Grid
## Base-Class for the two [Board] component classes, [Base] and [Field].[br]
## Uses a matrix to track and manipulate [Unit] placement.


# Constants
const LAYER = 0		## ID of the relevant [TileMap] layer used.


# Core Functions ------------------------------------------------------------- #

func _ready(): pass
func _start(): pass
func _reset(): pass


# Cell and Unit Management --------------------------------------------------- #

## Edge-SPECS for the [TileMap].[br]
## Note that this indicates that the matrix has
## [b].x rows[\b] [i](y-axis)[\i] and [b].y columns[\b] [i](x-axis)[\i].
@export var SPECS := Vector2i(12, 13)


## Creates a matrix to store information about [Unit] placement.
var GRID := ROOT.make_grid(SPECS.y + 1, SPECS.x + 1, null)


## Mode-Selection for [method Base.map_cell].
enum MODE { GET, SET }


## Unified setter and getter for the [member Base.GRID] cells, for clarity.[br]
## Note that the [param x] and [param y] values are swapped.
func map_cell(x: int, y: int, mode: MODE, value = null):
	match mode:
		MODE.GET: value = GRID[y][x]
		MODE.SET: GRID[y][x] = value
	return value


## Overload for passing a [Vector2i] directly to [method Base.map_cell].
func map_vector(cell: Vector2i, mode: MODE, value = null):
	return map_cell(cell.x, cell.y, mode, value)


## Checks if all cells are not occupied by a [Draggable].
func is_cleared() -> bool:
	for r in range(0, SPECS.x):
		for c in range(0, SPECS.y):
			var cell = map_cell(r, c, MODE.GET)
			if cell: return false
	return true


## Resets all cells' data to [b]null[\b].
func clear_cells():
	for r in range(0, SPECS.x):
		for c in range(0, SPECS.y):
			map_cell(r, c, MODE.SET, null)
	#print_grid('CLEAR')


## Updates all cells occupied by a [Draggable].
func update_cells():
	clear_cells()
	for unit: Unit in get_children():
		var cell := local_to_map(unit.position)
		map_vector(cell, MODE.SET, unit)
	#print_grid('UPDATE')
	

## Snaps the given [param unit], if exists, to the given [param cell].[br]
## Also applies [method map_vector] to synchronise the [member Base.GRID].
func snap_to(cell: Vector2i, unit = null):
	map_vector(cell, MODE.SET, unit)
	if unit:
		var pos := to_global(map_to_local(cell))
		unit.set_global_position(pos)
		unit.originate(pos)


# Debugging ------------------------------------------------------------------ #

## Prints out the [member Base.GRID], using the follwing symbols:[br]
## > [b]"-"[\b] : An invalid cell.[br]
## > [b]"0"[\b] : An empty, valid cell.[br]
## > [b]"%d"[\b] : The [member Unit.TYPE] of the [Draggable] occupying the cell.
func print_grid(section: String):

	print('[%s] %s:' % [ name, section ])

	var cells := get_used_cells(LAYER)

	for r in range(0, SPECS.x):

		var row := ""

		for c in range(0, SPECS.y):

			if Vector2i(c, r) in cells:

				#row += '%02d:%02d' % [ r, c ]

				var type := 0
				var unit = GRID[r][c]
				if unit: type = unit.TYPE

				row += '%02d' % type

			#else: row += '--:--'
			else: row += '--' 

			row += ' '

		print(row)
	print()
