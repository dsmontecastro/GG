extends Node
## Handles any P2P or inter-user communication on a [b]global[/b] level.


# Core Functions ------------------------------------------------------------- #

## Tracker for the opponent's [Steam] ID.
var ENEMY_ID := 0


func _ready():
	Steam.p2p_session_connect_fail.connect(on_failure)
	Steam.p2p_session_request.connect(on_request)


## (Re)sets [member P2P.ENEMY_ID] from [member LOBBY.MEMBERS].
func _start():
	_reset()
	for id in LOBBY.MEMBERS:
		if id != USER.ID:
			ENEMY_ID = id
			break


## Sets [member P2P.ENEMY_ID] from [member LOBBY.MEMBERS].
func _reset(): ENEMY_ID = 0


## Runs [method Steam.run_callbacks] in intervals.
func _process(_d): Steam.run_callbacks()


# Initializaiton ------------------------------------------------------------- #

## Performs a P2P 'handshake' with all other [member ROOM.MEMBERS].
func handshake():
	for ID in LOBBY.MEMBERS:
		if ID != USER.ID: send(P2P.MSSG.HANDSHAKE)


## Starts a P2P-Session with user#[param id].
func on_request(id: int):
	Steam.acceptP2PSessionWithUser(id)
	handshake()


## Displays an [Error] page given the user [param id] and the [param err] code.
func on_failure(id: int, err: int):

	var message = 'WARNING: Session failure with ID: %d [_].' % id

	match err:
		0: message.replace('_', 'No error given')
		1: message.replace('_', 'Target User not running the same game')
		2: message.replace('_', 'Local User doesn\'t own app / game')
		3: message.replace('_', 'Target User isn\'t connected to Steam')
		4: message.replace('_', 'Connection timed out')
		5: message.replace('_', '[unused]')
		_: message.replace('_', 'Unknown error (Code: %d)' % err)

	SIGNALS.emit_signal(SIGNALS.ERR.ERROR, message)


# Messaging ------------------------------------------------------------------ #

const PORT = 0							## Default port used.
const SEND = Steam.P2P_SEND_RELIABLE	## Default [enum Steam.P2PSend] type.
const NULL = 'Error: Empty packet!'		## Default [Error] message.


## Sends a [Message] to the [member P2P.ENEMY_ID].
func send(type: TYPE = TYPE.NULL, success = true):
	var data := Message.new(type, success)
	Steam.sendP2PPacket(ENEMY_ID, data.pack(), SEND, PORT)
	print('Sent: ', data.to_dict())


## Reads and processses a received [b] [Steam] packet[/b].
func read() -> Message:

	var data: Message = Message.new()
	var size := Steam.getAvailableP2PPacketSize(PORT)

	if size > 0:

		var packet: Dictionary = Steam.readP2PPacket(size, 0)

		if packet.is_empty() or packet == null:
			SIGNALS.emit_signal(SIGNALS.ERR.ERROR, NULL)

		elif packet['steam_id_remote'] in LOBBY.MEMBERS:
			data.unpack(packet[data])

		else: SIGNALS.emit_signal(SIGNALS.ERR.ERROR, NULL)

	return data


# Message Class -------------------------------------------------------------- #

## Codes used for translating sending and reading messages.
enum TYPE {
	NULL, HANDSHAKE,
	ALL_READY, PLAY_GAME, GAME_OVER,
	SWAP_TURN, MOVE_UNIT, KILL_UNIT
}


## Template for handling [b]messages[/b] between users.
class Message:

	# Properties and Contructors --------------------------------------------- #

	var type: TYPE		## Message [enum Message.TYPE]
	var value: bool		## Message value


	func _init(d_value: bool = false, d_type: TYPE = TYPE.NULL):
		value = d_value
		type = d_type

	# Conversions to-or-from Packets ----------------------------------------- #

	## Packs the properties into a [PackedByteArray] object.
	func pack() -> PackedByteArray:
		return var_to_bytes(to_dict())


	## Unpacks the given [param data], setting the appropriate properties.
	func unpack(data: Dictionary):
		for key in data: set(key, data[key])


	## Outputs a [Dictionary] of all properties and their values.
	func to_dict() -> Dictionary:
		var data = {}
		for prop in get_property_list():
			var key = prop['name']
			var val = get(key)
			if value: data[key] = val
		return data
