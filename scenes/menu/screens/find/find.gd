extends Screen
class_name FindScreen

# Constants
const MODE = LOBBY.MODE.AUTO
const TYPE = LOBBY.TYPE.INVISIBLE

# Member Scenes
@onready var Counter: Label = $%Counter
@onready var Cancel: Button = $%Cancel


# Core Functions ------------------------------------------------------------- #

func _ready(): set_process(false)


## Starts matchmaking.
func _start():
	Cancel.grab_focus()
	SIGNALS.find_lobbies.connect(matchmaking)
	SIGNALS.host_success.connect(_success)
	SIGNALS.join_success.connect(_success)
	set_counter(0, 0)
	set_process(true)
	find_match()
	show()


## Ends matchmaking.
func _reset():
	if visible:
		LOBBY._leave()
		SIGNALS.find_lobbies.disconnect(matchmaking)
		SIGNALS.host_success.disconnect(_success)
		SIGNALS.join_success.disconnect(_success)
		set_process(false)
		hide()


## Additionaly applies [method FindScreen._reset].
func _err(msg: String):
	super._err(msg)
	_reset()


# TIMEr Functions ------------------------------------------------------------------------------- #

## Generic error message to be supplied to [method Screen._err].
const TIMEOUT = 'Failed to automatically match you with a lobby. Please try again.'

## Distance parameter for [method FindScreen.matchmaking].
var DIST := LOBBY.DIST.CLOSE

## Tracker for the TIME passed and to be displayed.
var TIME := 0.0


## Sets the text in the [i]mm:ss[/i] format for [member FindScreen.Counter].
func set_counter(mins: int = 0, secs: int = 0):
	Counter.text = '%02d : %02d' % [mins, secs]


## Increments [member FindScreen.TIME] and [member FindScreen.DIST].
func _process(delta):

	if DIST < 4:

		TIME += delta
		var secs: int = int(TIME) % 60
		var mins: int = int(TIME / 60) % 60

		set_counter(mins, secs)

		if mins > 0 and !(secs % 30):
			DIST = (DIST + 1) as LOBBY.DIST
			if HOSTING: find_match()

	else: _err(TIMEOUT)


# Matchmaking Attempts ------------------------------------------------------- #

## Tracker for whether [FindScreen] is currently 'hosting' a match or not.
var HOSTING := false


## Attempts to find matches.
func find_match():
	LOBBY._leave()
	LOBBY.request_lobbies(MODE, DIST)
	HOSTING = false


## Attempts to host a match.
func host_match(): 
	LOBBY._leave()
	LOBBY.host_lobby(MODE, TYPE)
	HOSTING = true


## Finds a match given [param lobbies] retrieved from [Steam].[br]
## If none are available, the user will start hosting their own lobby.
func matchmaking(lobbies: Array):

	if lobbies.size() > 0:

		for id in lobbies:
			LOBBY._debug(id)
			if id != LOBBY.ID:
				LOBBY.join_lobby(id)
				return

	else: host_match()
