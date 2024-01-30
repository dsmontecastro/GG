extends Grid
class_name Base
## Where the [Unit]s spawn and set into formation once on the [Field].[br]
## Allows the [USER] to drag-and-drop said [Units] to set-up their formation.


# Constants
var DRAG_TO := SIGNALS.drag_to.get_name()


# Core Functions ------------------------------------------------------------- #

## Initializes the [Node] and connect the necessary [SIGNALS].
func _ready():
	SIGNALS.game_start.connect(_start)
	SIGNALS.game_reset.connect(_reset)
	_reset()


## Resets the modulation and hides the [TileMap].
func _start():
	_setup(true)
	lighten()
	hide()


## Resets all [Draggables] and subsequently [method update_cells].[br]
## This also enables the [b]drag-and-drop[/b] functionality, if disabled.
func _reset():

	for child: Draggable in get_children():
		child._reset()
	update_cells()
	show()

	if not SIGNALS.is_connected(DRAG_TO, drag_unit):
		SIGNALS.drag_to.connect(drag_unit)


## Disables [b]drag-and-drop[/b] functionality, if [param val] is [b]true[/b].
func _setup(val: bool):
	if val: SIGNALS.drag_to.disconnect(drag_unit)


# Base and Unit Visibility --------------------------------------------------- #

## Toggle visibility of the self.
func show_self(val: bool): visible = val


## Toggle visibility of all [Draggable]s.
func show_units(val: bool):
	for child: Draggable in get_children():
		child.visible = val


# Drag-and-Drop -------------------------------------------------------------- #

## Retrieves and records the valid cells used in the [TileMap].
@onready var VALID_CELLS := get_used_cells(LAYER)


## Drags the child [param unit] towards the given [param pos], if possible.[br]
## If the drag is invalid, forces a [method Draggable.snap_back].
func drag_unit(unit: Draggable, origin: Vector2, mouse: Vector2):

	if unit.get_parent() == self:

		var to := local_to_map(mouse)

		if to in VALID_CELLS:
			
			var from := local_to_map(origin)
			var target = map_vector(to, MODE.GET)

			snap_to(from, target)
			snap_to(to, unit)

			return

	unit.snap_back()
