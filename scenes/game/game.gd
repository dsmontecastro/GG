extends Node2D
class_name Game
## [Game]-Controller class, used to control its multiple children components.
## This sections contains the base elements and common methods.


# Member Scenes
@onready var BOARD = $Board
@onready var SIDE = $Sidebar

# Trackers
var READY := false


# Core Functions ------------------------------------------------------------- #

func _ready():
	SIGNALS.users_update.connect(lobby_change)
	SIGNALS.game_setup.connect(_setup)
	SIGNALS.game_start.connect(_start)
	SIGNALS.game_reset.connect(_reset)
	SIGNALS.game_reset.emit()
	P2P._start()


func _start():
	print('SIGNAL EMITTED: GAME_START')


func _reset():
	print('SIGNAL EMITTED: GAME_RESET')


## Sets the [member Game.READY] state.
func _setup(val: bool):
	print('SIGNAL EMITTED: SETUP(%s)' % val)
	print('ACTUAL READY STATE: %s' % USER.READIED)


# Real-time Processing ------------------------------------------------------- #

## 
func _process(_d):
	var data := P2P.read()
	if not data.empty: _parse(data)


## 
func _parse(data: P2P.Message):

	var msg = data.message
	var _val = data.value

	print('Received: %s' % msg)

	match msg:
		P2P.MSSG.ALL_READY: SIGNALS.game_start.emit()


# Setup Functions ------------------------------------------------------------ #

## 
func lobby_change(state: int, _msg: String):

	P2P._start()

	if state > 1:	## Player Left/Kicked/Banned

		READY = false
		USER.IN_GAME = false
		SIGNALS.game_reset.emit()

		## Host has left; remaining user is now the [b]host[/b].
		if not USER.HOSTING: USER.HOSTING = true

	SIDE.update()
