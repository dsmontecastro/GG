extends Node


# Enumerations
enum TYPE { PRIVATE, FRIENDS, PUBLIC, INVISIBLE }	## Shortcut for [enum Steam.LobbyType].
enum DIST { CLOSE, DEF, FAR, GLOBAL }				## Shortcut for [enum Steam.LobbyDistanceFilter].
enum META { NAME, HOST, MODE, FORM }				## Custom types used in user and lobby metadata.
enum MODE { AUTO, MANUAL }							## Custom modes used in lobby matchmaking.

# Constants
const TAG = '[GoG] '							## Tag to precede any lobby name.
const MAX_MEMBERS = 2							## Maximum amount of players in a lobby.
const FILTER_GTE = 2 as Steam.LobbyComparison	## Shortcut for '>=' (missing from autocomplete).
const FILTER_EQ = 0 as Steam.LobbyComparison	## Shortcut for '=='.

# Trackers
var FIND := MODE.AUTO		## Tracker for the current Find-[enum MODE].


# Core Functions ------------------------------------------------------------- #

func _ready():

	# Host / Join Signals
	Steam.lobby_created.connect(host_status)
	Steam.lobby_joined.connect(join_status)
	Steam.join_requested.connect(join_by_invite)

	# Lobby / Update Signals
	Steam.lobby_match_list.connect(get_lobbies)
	Steam.lobby_data_update.connect(data_update)
	Steam.lobby_chat_update.connect(users_update)
	Steam.persona_state_change.connect(user_update)

	## @tutorial: https://godotsteam.com/tutorials/lobbies/
	var args: Array = OS.get_cmdline_args()

	if args.size() > 0:
		if args[0] == '+connect_lobby':
			if int(args[1]) > 0:
				join_lobby(int(args[1]))
				print('CMD Line Lobby ID: ' + str(args[1]))


## Resets [member LOBBY.FIND], [ROOM], and [USER] to their initial values.
func _reset():
	FIND = MODE.AUTO
	ROOM._reset()
	USER._reset()


## Leves the [ROOM] and performs a [method LOBBY._reset].
func _leave():
	ROOM._leave()
	_reset()


## [TEST] Prints out the current lobby information, if exists.
func _debug():

	var id := ROOM.ID

	if id <= 0: return 'Error: Invalid lobby.'

	else:

		var info = [id]
		info.append(Steam.getNumLobbyMembers(id))
		info.append(Steam.getLobbyMemberLimit(id))
		info.append(Steam.getLobbyData(id, str(META.NAME)))
		info.append(Steam.getLobbyData(id, str(META.HOST)))
		info.append(Steam.getLobbyData(id, str(META.MODE)))

		return '%d (%d/%d) [%s]: \'%s\' by %s' % info


# Lobby Updates -------------------------------------------------------------- #

## Enacted on [signal Steam.persona_state_change].[br]
## Indicates that a [b]member[/b] has updated their data.
func user_update(_userID: int, _flag: int): update_members()


## Enacted on [signal Steam.lobby_data_update].[br]
## Indicates that the [ROOM] metadata has been updated.
func data_update(success: int, id: int, userID: int):

	## @tutorial: https://godotsteam.com/classes/matchmaking/#getlobbymemberdata
	if id != userID:

		var message := 'Change to %s ' % userID

		if success: message += 'successful!'
		else: message += 'failed...'
		print(message)

		update_members()
		SIGNALS.data_update.emit(success, message)


## Enacted on [signal Steam.lobby_chat_update].[br]
## Indicates that a [class ROOM.Member] has joined or left the [ROOM].
func users_update(_id: int, changedID: int, _changerID: int, state: int):

	var changedName := Steam.getFriendPersonaName(changedID)

	var message := '%s has _ the lobby.' % changedName

	match state:
		01: message.replace('_', 'joined')
		02: message.replace('_', 'left')
		08: message.replace('_', 'been kicked from')
		16: message.replace('_', 'been banned from')
		_:  message = '%s has done... something.' % changedName
	print(message)

	update_members()
	SIGNALS.room_update.emit(state, message)


## Updates [member ROOM.MEMBERS] to reflect any [Steam]-side changes.
func update_members():

	ROOM.clear()
	var id := ROOM.ID

	var count = Steam.getNumLobbyMembers(id)

	for index in range(0, count):
		var userID = Steam.getLobbyMemberByIndex(id, index)
		var userName = Steam.getFriendPersonaName(userID)
		var userForm = Steam.getLobbyMemberData(id, userID, str(META.FORM))
		ROOM.add(userID, userName, userForm)


# Matchmaking Functions ------------------------------------------------------ #

## Requests lobbies given the indicated specs.
func request_lobbies(mode: int = MODE.AUTO,
					 dist: int = DIST.GLOBAL,
					 title: String = ''):
	Steam.addRequestLobbyListStringFilter('mode', str(mode), FILTER_EQ)
	Steam.addRequestLobbyListStringFilter('name', TAG + title, FILTER_GTE)
	Steam.addRequestLobbyListDistanceFilter(dist as Steam.LobbyDistanceFilter)
	Steam.requestLobbyList()


## Recieves the requested [Array] of [param lobbies] and emits it elsewhere.
func get_lobbies(lobbies: Array): SIGNALS.found_lobbies.emit(lobbies)


# Hosting -------------------------------------------------------------------- #

## Attempts to [b]host[/b] a lobby given the indicated specs.
func host_lobby(mode: int, type: int, title: String = ''):
	ROOM.NAME = title
	FIND = mode as MODE
	Steam.createLobby(type as Steam.LobbyType, MAX_MEMBERS)


## Response to the [b]hosting[/b] request, emitted to elsewhere.
func host_status(connection: int, id: int):

	var success := true
	var message := 'Lobby created successfully!'

	if connection == 1:

		ROOM.ID = id
		USER.HOSTING = true
		if !ROOM.NAME: ROOM.NAME = str(id)

		Steam.setLobbyData(id, str(META.NAME), TAG + ROOM.NAME)
		Steam.setLobbyData(id, str(META.HOST), USER.NAME)
		Steam.setLobbyData(id, str(META.MODE), str(FIND))
		Steam.setLobbyJoinable(id, true)
		Steam.allowP2PPacketRelay(true)

	else:
		_reset()
		success = false
		match connect:
			02: message = 'The server responded, but with an unknown internal error.'
			03: message = 'Your Steam client doesn\'t have a connection to the back-end.'
			15: message = 'Your Steam client doesn\'t have access to the game or the lobby.'
			16: message = 'The message was sent to the Steam servers, but it didn\'t respond.'
			25: message = 'You have created too many lobbies and are being rate limited.'

	SIGNALS.host_response.emit(success, message)


# Joining Functions ---------------------------------------------------------- #

## Attempts to [b]join[/b] a lobby with the give [param id].
func join_lobby(id: int): Steam.joinLobby(id)


## Attempts to [b]join[/b] a lobby generated from a [b]friend invite[/b].
func join_by_invite(id: int, friendID: int):
	var friend = Steam.getFriendPersonaName(friendID)
	print('Joining %s\'s lobby...' % friend)
	join_lobby(id)


## Response to a [b]join[/b] request, emitted to elsewhere.
func join_status(id: int, _permissions: int, _locked: bool, response: int):

	var host := true
	var success := true
	var message := 'Lobby joined successfully!'

	if response == 1:

		if id != ROOM.ID:
			host = false
			_leave()

		ROOM.ID = id
		ROOM.NAME = Steam.getLobbyData(id, str(META.NAME),)
		FIND = int(Steam.getLobbyData(id, str(META.MODE),)) as MODE

		Steam.setLobbyMemberData(id, str(META.FORM), '')
		update_members()
		P2P.handshake()

	else:
		success = false
		match response:
			02: message = 'This lobby no longer exists.'
			03: message = 'You don\'t have permission to join this lobby.'
			04: message = 'The lobby is now full.'
			05: message = 'Uh... something unexpected happened!'
			06: message = 'You are banned from this lobby.'
			07: message = 'You cannot join due to having a limited account.'
			08: message = 'This lobby is locked or disabled.'
			09: message = 'This lobby is community locked.'
			10: message = 'A user in the lobby has blocked you from joining.'
			11: message = 'A user you have blocked is in the lobby.'

	if not host: SIGNALS.join_response.emit(success, message)


# Setup Functions ------------------------------------------------------------ #

## Updates the [USER]'s [param form] on the [LOBBY] [class P2P.Member] data.
func setup(formation: Array[Array]):
	var form := str(formation)
	Steam.setLobbyMemberData(ROOM.ID, str(META.FORM), form)


## Checks to see if all members are 'ready' to start the [Game].
func all_ready() -> bool:
	
	var id := ROOM.ID

	if Steam.getNumLobbyMembers(id) < MAX_MEMBERS: return false

	for userID in ROOM.MEMBERS:
		var form := Steam.getLobbyMemberData(id, userID, str(META.FORM))
		if not form: return false

	return true


# Gameplay Functions --------------------------------------------------------- #
