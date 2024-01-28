extends Grid
class_name Base
## Where the [Unit]s spawn and set into formation once on the [Field].[br]
## Allows the [USER] to drag-and-drop said [Units] to set-up their formation.


# Core Functions ------------------------------------------------------------- #

## Initialize the [Node] and connect the necessary signals.
func _ready():
	SIGNALS.game_start.connect(_start)
	SIGNALS.game_reset.connect(_reset)
	SIGNALS.drag_to.connect(drag_unit)
	_reset()


## Disconnect the relevant signals on [signal SIGNALS.game_start].
func _start():
	SIGNALS.game_start.disconnect(_start)
	SIGNALS.game_reset.disconnect(_reset)
	SIGNALS.drag_to.disconnect(drag_unit)
	hide()


## Resets all [Draggables] and subsequently [method update_cells].
func _reset():
	for child: Draggable in get_children():
		child._reset()
	update_cells()
	show()


## [TODO] Unsure
func _setup(val: bool): pass


# Color Handling ------------------------------------------------------------- #

## References for the [Color]s used in modulation.
const COLORS = {
	DEF = Color(0,0,0,0),
	DARK = Color(0,0,0,0.5),
	LITE = Color(1,1,1,0.5)
}


## Resets the modulation for the [TileMap].
func reset_color(): set_layer_modulate(LAYER, COLORS.DEF)


## Brightens or darkens the [TileMap] based on the current modulation.
func toggle_color():

	var color = COLORS.DEF
	var curr = get_layer_modulate(LAYER)

	if curr == COLORS.DARK: color = COLORS.LITE
	elif curr == COLORS.LITE: color = COLORS.DARK
	
	set_layer_modulate(LAYER, color)
	print("%s: %s" % [self.name, self.modulate])


# Base and Unit Visibility --------------------------------------------------- #

## Toggle visibility of the self.
func show_self(val: bool): visible = val


## Toggle visibility of all [Draggable]s.
func show_units(val: bool):
	for child: Draggable in get_children():
		child.visible = val


# Drag-and-Drop -------------------------------------------------------------- #

## Drags the child [param unit] towards the given [param pos], if possible.[br]
## If the drag is invalid, forces a [method Draggable.snap_back].
func drag_unit(unit: Draggable, pos: Vector2):

	if unit.get_parent() == self:

		var to := local_to_map(pos)
		snap_to(to, unit)

		var from := local_to_map(unit.get_position())
		var target = map_vector(to, MODE.GET)
		snap_to(from, target)

	unit.snap_back()
