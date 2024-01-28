extends PanelContainer
class_name Profile
## Holds the basic [USER] controls and information
## of its respective [class ROOM.Member].


# Constants
const SIZE = 128
const FORMAT = Image.FORMAT_RGBA8
const INTERPOLATION = Image.INTERPOLATE_LANCZOS

# Member Scenes
@onready var NAME: Label = $%Name
@onready var TEAM: Panel = $%Team
@onready var ICON: TextureRect = $%Icon
@onready var FORFEIT: Button = $%Forfeit
@onready var BUTTONS: HBoxContainer = $%Buttons
@onready var VERTICAL: VBoxContainer = $%Vertical

# Tracker(s)
var COLOR := Color.WHITE


# Core Functions ------------------------------------------------------------- #

## Initializes the [Object] and connects the relevant [signal]s.
func _ready():
	SIGNALS.game_reset.connect(_reset)
	SIGNALS.game_start.connect(_start)
	_reset()


## Toggles the buttons' disabled states to [b]true[\b],
## where only [member Profile.Forfeit] is [b]active[\b].
func _start(): disable(true)


## Toggles the buttons' disabled states to [b]false[\b],
## where only [member Profile.Forfeit] is [b]inactive[\b].
func _reset(): disable(false)


# Setup Functions ------------------------------------------------------------ #

## Toggles the [b]disabled[/b] state of all buttons in [member Profile.BUTTONS].
func disable(val: bool = false):
	for button in BUTTONS.get_children():
		if button is Button:
			if button == FORFEIT:
				button.disabled = !val
			else: button.disabled = val


## Swaps the order of elements in [member Profile.VERTICAL].
func reverse():
	var child = VERTICAL.get_child(0)
	VERTICAL.move_child(child, -1)


# Profile Functions ---------------------------------------------------------- #

## Immediately surrenders the [Game], if exists.
func forfeit():
	if USER.IN_GAME: SIGNALS.forfeit.emit()


## Toggles whether the [USER] is ready to start the game or not.
func ready_toggled(val: bool):
	if not USER.IN_GAME: SIGNALS.game_setup.emit(val)


## Signals to reset the [USER]'s [Base] during setup.
func reset_board():
	if not USER.IN_GAME: SIGNALS.game_reset.emit()


## Updates the [member Profile.NAME] and [member Profile.ICON] elements using
## the provided parameters.
func update(
		user: String = '',
		data: PackedByteArray = PackedByteArray(),
		width: int = 0,
	):

	if user: NAME.text = user

	if not data.is_empty():

		var image := Image.create_from_data(width, width, false, FORMAT, data)
		if width > 128: image.resize(128, 128, INTERPOLATION)

		var texture = ImageTexture.create_from_image(image)
		ICON.set_texture(texture)
