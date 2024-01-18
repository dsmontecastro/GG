extends Unit
class_name Draggable

@onready var BASE: Base = get_parent()
@onready var START = global_position
@onready var ORIGIN = START

@onready var MIN: Vector2i = Vector2i.ZERO
@onready var MAX: Vector2i = Vector2i.ZERO

# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	connect("input_event", Callable(self, "drag_unit"))
	add_to_group("Allies", true)
	add_to_group("Units", true)
	set_process(false)

func _start():
	disconnect("input_event", Callable(self, "drag_unit"))

func _reset(): set_global_position(START)


# Initalizing Origin (for resetting Drag-&-Drop) ------------------------------------------------ #

func originate(pos: Vector2):
	ORIGIN = global_position
	set_position(pos)

# Drag-&-Drop Functions ------------------------------------------------------------------------- #

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var new_pos = lerp(global_position, mouse_pos, 25 * delta)
	set_global_position(new_pos)


const GROUP = "Units"
func toggle_drag(val: bool):

	if val:
		Anim.z_index = 15
		if GROUP in get_groups():
			remove_from_group(GROUP)
	else:
		Anim.z_index = 0
		add_to_group(GROUP)

	get_tree().call_group(GROUP, "mouse_toggle", !val)
	set_process(val)


func drag_unit(_vp, _event, _idx):

	if not USER.READIED:

		var locked = is_processing()

		if not locked and Input.is_action_just_pressed("Click"):
			toggle_drag(true)

		elif locked and Input.is_action_just_released("Click"):
			toggle_drag(false)
			if overlaps_body(BASE): snap_to_grid()
			else: snap_back()

# TileMap Positioning Functions ----------------------------------------------#

func snap_back(): set_global_position(ORIGIN)

func snap_to_grid():

	var coords: Vector2 = BASE.local_to_map(get_global_mouse_position())
	var data: TileData = BASE.get_cell_tile_data(0, coords)

	if data:

		var filled: bool = data.get_custom_data('filled')

		if filled: snap_back()
			
		else:

			data.set_custom_data('filled', !filled)
			var from: Vector2 = BASE.local_to_map(get_position())
			BASE.toggle_cell(from)

			set_position(BASE.map_to_local(coords))	
			ORIGIN = global_position

	else: snap_back()
