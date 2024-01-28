extends HBoxContainer
class_name Chat
## [TODO]


# Constants
const ITEM_TAG = 'ITEM-'

# Member Scenes 
@onready var WALL: VBoxContainer = $%Wall
@onready var MSSG: TextEdit = $%Message


# Core Functions ------------------------------------------------------------- #

## Clears the [member Chat.WALL] and [member Chat.Message] components.
func _reset():
	clear_messages()
	clear_message()


# Resetting ------------------------------------------------------------------ #

## Clears the [member Chat.Message] text.
func clear_message(): MSSG.clear()


## Empties the [member Chat.WALL] of its [ChatItem] children.
func clear_messages():
	for item in WALL.get_children():
		item.free()
