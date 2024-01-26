extends Unit
class_name Draggable
## Allows drag-and-drop functionality for the [Unit] class.[br]
## This [Draggable] can only be placed within its respective [Base].


# Constants
const INPUT = 'Click'
const UNITS = 'Units'
const ALLIES = 'Allies'


## Parent Base
@onready var BASE: Base = get_parent()


## Initial global position where the [Unit] is spawned from.
@onready var START := global_position


## Global position to [method Draggable.snap_back] to.
@onready var ORIGIN := START


# Core Functions ------------------------------------------------------------- #

func _ready():
	self.input_event.connect(drag)
	add_to_group(ALLIES, true)
	add_to_group(UNITS, true)
	set_process(false)


## Moves the [Unit] back to its [member DRAG.START] position.
func _start(): set_global_position(START)


## Disables the ability to do [method Draggable.drag] this [Unit].
func _reset(): self.input_event.disconnect(drag)


## When enabled, binds the [Unit] to the global mouse position.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var new_pos = lerp(global_position, mouse_pos, 25 * delta)
	set_global_position(new_pos)


# Drag-&-Drop Functions ------------------------------------------------------ #

## Sets the [method Draggable.snap_back] location for this unit, in case
## [method Draggable.drag] is cancelled or [method Draggable.snap_back] fails.
func originate(pos: Vector2):
	ORIGIN = global_position
	set_position(pos)


## Attaches the [Unit] to the mouse via [method Draggable._process].
func shadow(val: bool):

	if val:
		ANIM.z_index = 15
		if UNITS in get_groups():
			remove_from_group(UNITS)
	else:
		ANIM.z_index = 0
		add_to_group(UNITS)

	get_tree().call_group(UNITS, 'mouse_toggle', !val)
	set_process(val)


## Controls mouse interactions with the [Unit].
func drag(_vp, _event, _idx):

	if not USER.IN_GAME:

		var locked := is_processing()

		## Enable [method Draggable.shadow]
		if not locked and Input.is_action_just_pressed(INPUT):
			shadow(true)

		## Disable [method Draggable.shadow] and "drop" [Unit].
		elif locked and Input.is_action_just_released(INPUT):
			shadow(false)

			if overlaps_body(BASE): snap_to()
			else: snap_back()


# Positioning Functions ------------------------------------------------------ #

## Repositions the [Draggable] to its [member Draggable.ORIGIN].
func snap_back(): set_global_position(ORIGIN)


## Attempts to position the [Draggable] to the current mouse position.
func snap_to():
	var pos := get_global_mouse_position()
	SIGNALS.drag_to.emit(self, pos)
