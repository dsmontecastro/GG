extends PanelContainer
class_name Profile
## Holds the basic [USER] controls and information
## of its respective [class ROOM.Member].


# Constants
const SIZE = 128
const FORMAT = Image.FORMAT_RGBA8
const INTERPOLATION = Image.INTERPOLATE_LANCZOS

# Enumerations
enum MODE { GAME, SETUP, ENEMY }

# Member Scenes
@onready var NAME: Label = $%Name
@onready var TEAM: Panel = $%Team
@onready var ICON: TextureRect = $%Icon
@onready var FORFEIT: Button = $%Forfeit
@onready var BUTTONS: HBoxContainer = $%Buttons
@onready var VERTICAL: VBoxContainer = $%Vertical


# Core Functions ------------------------------------------------------------- #

## Initializes the [Object] and connects the relevant [signal]s.
func _ready(): pass


## [TODO] Unsure.
func _start(): pass


## [TODO] Unsure.
func _reset(): pass


# Setup Functions ------------------------------------------------------------ #

## Toggles the [b]disabled[/b] state of all [member Profile.BUTTONS].[br]
## The behavior changes depending on the supplied [enum Profile.MODE]:[br]
## > GAME: [member Profile.FORFEIT] enabled; rest are disabled.[br]
## > SETUP: [member Profile.FORFEIT] disabled; rest are enabled.[br]
## > ENEMY: all buttons are disabled.[br]
func toggle_buttons(mode: MODE):

	var value := (mode != MODE.SETUP)

	for button in BUTTONS.get_children():
		if button is Button:
			button.disabled = value

	FORFEIT.disabled = (mode != MODE.GAME)


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
