extends TileMap
class_name Base
## The spawn-points for the [Unit]s to be set on the [Field].[br]
## Allows the [USER] to drag-and-drop said [Units] to set-up their formation.


# Constants
const DATA = 'filled'
const COLORS = {
	DEF = Color(0,0,0,0),
	DARK = Color(0,0,0,0.5),
	LITE = Color(1,1,1,0.5)
}

## 
enum LAYERS { BASE, BOARD }


# Core Functions ------------------------------------------------------------- #

func _ready():
	SIGNALS.drag_to.connect(drag_unit)
	update()


## Resets the modulation for the [TileMap].
func _reset(): set_layer_modulate(LAYERS.BOARD, COLORS.DEF)


# Color Handling ------------------------------------------------------------- #

#func darken(): set_layer_modulate(LAYERS.BOARD, COLORS.DARK)
#func lighten(): set_layer_modulate(LAYERS.BOARD, COLORS.LITE)

## Brightens or darkens the [TileMap] based on the current modulation.
func toggle():

	var color = COLORS.DEF
	var curr = get_layer_modulate(LAYERS.BOARD)

	if curr == COLORS.DARK: color = COLORS.LITE
	elif curr == COLORS.LITE: color = COLORS.DARK
	
	set_layer_modulate(LAYERS.BOARD, color)
	print("%s: %s" % [self.name, self.modulate])


# Drag-based Functions ------------------------------------------------------- # 

## Marks all child [Draggable]s' cells on the custom [member Base.DATA] layer.
func update():
	for child: Draggable in get_children():
		var cell = local_to_map(child.position)
		toggle_cell(cell)


## Toggles the given [param cell] on the custom [member Base.DATA] layer.
func toggle_cell(cell: Vector2i):
	var data: TileData = get_cell_tile_data(0, cell)
	if data:
		var filled: bool = data.get_custom_data(DATA)
		data.set_custom_data(DATA, !filled)


## Drags the child [param unit] towards the given [param pos], if possible.[br]
## If the drag is invalid, forces a [method Draggable.snap_back].
func drag_unit(unit: Draggable, pos: Vector2):

	if unit.get_parent() == self:

		var cell := local_to_map(pos)
		var data := get_cell_tile_data(0, cell)

		if data:

			var filled: bool = data.get_custom_data(DATA)

			if not filled:

				data.set_custom_data(DATA, !filled)

				var from := local_to_map(unit.get_position())
				toggle_cell(from)

				var to := to_global(map_to_local(cell))
				unit.set_global_position(to)
				unit.originate(to)
				
				return

	unit.snap_back()
