extends Moveable
class_name Enemy


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	FILTER.show()
	add_to_group(GROUPS.ENEMY)
	self.input_event.connect(cycle_unit)


func init(type: int, team: TEAMS):
	set_team(team)
	set_type(type)
	cycle(0)


# Cycling Toggle -------------------------------------------------------------------------------- #

var ACTIVE = true
func toggle(val: bool): ACTIVE = val


# Icon Cycling ---------------------------------------------------------------------------------- #

var ICON = 0

const INPUTS = {
	L_CLICK = CLICK,
	R_CLICK = 'R-Click',
	SWAP_PREV = 'Swap-Prev',
	SWAP_NEXT = 'Swap-Next',
}

func cycle_unit(_v, _e, _i):

	if ACTIVE:

		var l_click = Input.is_action_just_pressed(INPUTS.L_CLICK)
		var r_click = Input.is_action_just_pressed(INPUTS.R_CLICK)
		var swap_prev = Input.is_action_just_released(INPUTS.SWAP_PREV)
		var swap_next = Input.is_action_just_released(INPUTS.SWAP_NEXT)

		var icon = ICON
		if l_click or swap_next: icon += 1
		elif r_click or swap_prev: icon -= 1
		
		if icon != ICON: cycle(icon)


# Helper Functions ------------------------------------------------------------------------------ #

func cycle(icon: int):
	ICON = icon % TYPES
	if ICON < 0: ICON += TYPES
	swap_anim(ICON)
	redirect()

func redirect():
	if TEAM == TEAMS.BLACK:
		if ICON > 1:
			orient_to(ORIENTATION + PI)
		else: orient_to(0)
