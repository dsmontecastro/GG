extends Screen
class_name MakeScreen
## [b]Options [Screen][/b] component, used to modify global settings.
## [NOTE]: The [Settings] configuration is still uninmplemented.

# Constants
const GAME = 'res://Game/Game.tscn'
const MODE = LOBBY.MODE.MANUAL
const DIST = LOBBY.DIST.GLOBAL
const LOBBY_TAG = 'Lobby_'

# Member Scenes
@onready var LOBBIES: VBoxContainer = $%Lobbies
@onready var HOST_TYPE: OptionButton = $%HostType
@onready var HOST_NAME: LineEdit = $%HostName
@onready var FIND_NAME: LineEdit = $%FindName
@onready var FIND_BUTT: Button = $%FindButt
@onready var CANCEL: Button = $%Cancel


## The preloaded [LobbyButton] scene.
var LOBBY_BUTT := preload('lobby_button/lobby_button.tscn')


# Core Funtions -------------------------------------------------------------------------------- #

func _ready():

	SIGNALS.find_lobbies.connect(list_rooms)
	SIGNALS.host_success.connect(_success)
	SIGNALS.join_success.connect(_success)

	for item in LOBBY.TYPE:
		HOST_TYPE.add_item(item, LOBBY.TYPE[item])
	HOST_TYPE.select(LOBBY.TYPE.PUBLIC)


## Refocuses to [member HOST_NAME ] and initializes the rooms list.
func _start():
	HOST_NAME.grab_focus()
	find_rooms()


## Leaves the current room joined, if exists.
func _reset():  LOBBY._leave()


# Lobby Requests ------------------------------------------------------------- #

## Requests to host a room name to the text in [member MakeScreen.HostName].
func host_room():
	if HOST_NAME .text:
		var lobby_name := HOST_NAME.text
		var lobby_type := HOST_TYPE.get_selected_id()
		LOBBY.host_lobby(MODE, lobby_type, lobby_name)


## Requests room(s) starting with the name in [member MakeScreen.FindName].
func find_rooms():
	var lobby_name := FIND_NAME.text.strip_edges()
	LOBBY.request_lobbies(MODE, DIST, lobby_name)


## Displays [param lobbies] in [member MakeScreen.LOBBIES] as [LobbyButton]s.[br]
## Additionally, focus mapping will be applied to all buttons as they are added.
func list_rooms(lobbies: Array):

	for child in LOBBIES.get_children(): child.queue_free()

	# Set default Focus Mapping
	if !lobbies:
		refocus_find(CANCEL)
		refocus_prev(CANCEL, FIND_BUTT)

	else:

		var i := -1
		for id in lobbies:

			var lobby: LobbyButton = LOBBY_BUTT.instantiate()
			lobby.name = '%s_%d' % [LOBBY_TAG, i]
			LOBBIES.add_child(lobby)

			lobby.set_name(Steam.getLobbyData(id, 'name'))
			lobby.set_host(Steam.getLobbyData(id, 'host'))
			lobby.set_id(id)

			if i < 0:
				refocus_find(lobby)
				refocus_prev(lobby, FIND_BUTT)

			else:
				var prev: LobbyButton = LOBBIES.get_child(i)
				refocus_next(prev, lobby)
				refocus_prev(lobby, prev)

			refocus_side(lobby)
			refocus_next(lobby, CANCEL)
			refocus_prev(CANCEL, lobby)
			i += 1


# Focus Mapping -------------------------------------------------------------- #

## Returns the [Button] associated in the give [Control] [param node].
func get_target(node: Control):
	if LOBBY_TAG in node.name:
		node = node.get_node('Title')
	return node


## Sets the next and/or bottom neighbors for [member MakeScreen.FIND_BUTT] and
## [member MakeScreen.FIND_NAME].
func refocus_find(node: Control = CANCEL):
	var path := get_target(node).get_path()
	FIND_NAME.focus_neighbor_bottom = path
	FIND_BUTT.focus_neighbor_bottom = path
	FIND_BUTT.focus_next = path


## Sets the left and right neighbors for the given [LobbyButton] [param node].
func refocus_side(node: LobbyButton):
	node = get_target(node)
	var path := node.get_path()
	node.focus_neighbor_left = path
	node.focus_neighbor_right = path


## Sets the next and bottom neighbors for the given [LobbyButton] [param node].
func refocus_next(node: Control, next: Control):
	node = get_target(node)
	next = get_target(next)
	var path := next.get_path()
	node.focus_neighbor_bottom = path
	node.focus_next = path


## Sets the previous and top neighbors for the given [LobbyButton] [param node].
func refocus_prev(node: Control, prev: Control):
	node = get_target(node)
	prev = get_target(prev)
	var path := prev.get_path()
	node.focus_neighbor_top = path
	node.focus_previous = path
