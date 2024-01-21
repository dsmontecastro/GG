extends MarginContainer
class_name LobbyButton

# Constants
const LIM = 15			## Maximum number of characters to be displayed in text.
const TAG = LOBBY.TAG	## String to be removed from [member LobbyButton.TITLE].

# Member Scenes
@onready var HOST: Label = $Host
@onready var TITLE: Button = $Title


# Core Functions ------------------------------------------------------------- #

## Joins the [Steam] lobby with a matching [member LobbyButton._id].
func _on_pressed(): LOBBY.join_lobby(_id)


# Text Setters --------------------------------------------------------------- #

## Tracker for the [b]ID[/b] assigned to the [LobbyButton].
var _id := -1

## Setter for [member LobbyButton._id].
func set_id(val: int): _id = val

## Setter for the text in [member LobbyButton.HOST].
func set_host(val: String): HOST.text = trim(val) + '    '

## Setter for the text in [member LobbyButton.TITLE].
func set_title(val: String):
	if val: val = val.replace(TAG, '')
	TITLE.text = '  ' + trim(val)


# Auxiliary Functions -------------------------------------------------------- #

## Trims the supplied string to a given [param limit].[br]
## If the string exceeds it,
## the last [b]3[/b] characters will be converted to an ellipsis.[br]
## The default length is [member LobbyButton.LIM].
func trim(text: String, limit: int = LIM) -> String:
	if len(text) > limit:
		text = text.substr(0, limit - 3) + '...'
	return text
