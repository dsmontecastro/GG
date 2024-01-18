extends Unit
class_name Foe


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	add_to_group("Units", true)
	add_to_group("Enemies", true)
	connect("input_event", Callable(self, "cycle_unit"))
	Glitch.show()


# Cycling Toggle -------------------------------------------------------------------------------- #

var ACTIVE = true
func toggle(val: bool): ACTIVE = val


# Icon Cycling ---------------------------------------------------------------------------------- #

var ICON = 16

func cycle_unit(_v, _e, _i):

	if not ACTIVE: return

	var click = Input.is_action_just_pressed("Click")
	var rClick = Input.is_action_just_pressed("RClick")
	var swapUp = Input.is_action_just_released("SwapUp")
	var swapDown = Input.is_action_just_released("SwapDown")

	var newIcon = ICON
	if click or swapUp: newIcon += 1
	elif rClick or swapDown: newIcon -= 1
	
	if newIcon != ICON: cycle(newIcon)


# Helper Functions ------------------------------------------------------------------------------ #

func cycle(val: int):
	ICON = val % TYPES
	if ICON < 0: ICON += TYPES
	swap_anim(ICON)
	redirect(ICON)

func redirect(val: int):
	if TEAM == -1:
		if val > 1: face_anim(DIR + PI)
		else: face_anim(0)
