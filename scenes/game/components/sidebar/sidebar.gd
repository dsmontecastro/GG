extends MarginContainer
class_name Sidebar
## Holds non-[Game] related [b]UI[\b] elements,
## such as [USER] elements and the [Chat] proper.


# Member Scenes
@onready var CHAT: Chat = $%Chat
@onready var BLACK: Profile = $%Black
@onready var WHITE: Profile = $%White
@onready var FOE := BLACK if USER.HOSTING else WHITE	## Foe's [Profile]
@onready var OWN := WHITE if USER.HOSTING else BLACK	## User's [Profile]


# Core Functions ------------------------------------------------------------- #

## Modifies the appearance of [member Sidebar.BLACK] and connects the
## relevant [signal]s.
func _ready():
	Steam.avatar_loaded.connect(profile_updated)
	FOE.toggle_buttons(Profile.MODE.ENEMY)
	BLACK.reverse()
	_reset()


## Disables the [member P2P.ENEMY] [Profile]'s buttons for the [USER].
func _start():
	OWN.toggle_buttons(Profile.MODE.GAME)


## Resets the [Chat] and [Profile] components.
func _reset():
	OWN.toggle_buttons(Profile.MODE.SETUP)
	update_profiles()
	CHAT._reset()


# Profile Functions ---------------------------------------------------------- #

## Request to updated profile avatars via [Steam].
func update_profiles():
	for id in ROOM.MEMBERS:
		Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, id)


## Processes received profile avatars based on [param id].
func profile_updated(id: int, width: int, data: PackedByteArray):

	var profile := OWN
	if id == P2P.ENEMY: profile = FOE

	if data.is_empty():
		var user: String = ROOM.MEMBERS[id].USER
		profile.update(user, data, width)
