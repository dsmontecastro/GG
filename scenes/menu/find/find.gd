extends MarginContainer

@onready var Counter = $"%Counter"
@onready var Cancel = $"%Cancel"


# Default Parameters
var DIST = LOBBY.DIST.CLOSE
const MODE = LOBBY.MODE.AUTO
const TYPE = LOBBY.TYPE.INVISIBLE


# Basic Functions ------------------------------------------------------------------------------ #

func _ready(): set_process(false)

func _start():
	Cancel.grab_focus()
	DIST = LOBBY.DIST.CLOSE
	SIGNALS.connect("find_lobbies", Callable(self, "matchmaking"))
	SIGNALS.connect("lobby_update", Callable(self, "match_hosted"))
	SIGNALS.connect("join_success", Callable(self, "match_joined"))
	set_counter(0, 0)
	set_process(true)
	find_match()
	self.show()
	
func _reset():
	if self.visible:
		LOBBY._leave()
		SIGNALS.disconnect("find_lobbies", Callable(self, "matchmaking"))
		SIGNALS.disconnect("lobby_update", Callable(self, "match_hosted"))
		SIGNALS.disconnect("join_success", Callable(self, "match_joined"))
		set_process(false)
		self.hide()


# Signaling Functions --------------------------------------------------------------------------- #

func _play(msg: String):
	SIGNALS.emit_signal("play", msg)

func _error(msg: String):
	SIGNALS.emit_signal("warning", msg)
	_reset()


# Timer Functions ------------------------------------------------------------------------------- #

var time = 0.0
const TIMEOUT = "Failed to automatically match you with a lobby. Please try again."

func set_counter(mins: int = 0, secs: int = 0):
	Counter.text = "%02d : %02d" % [mins, secs]

func _process(delta):

	if DIST < 4:

		time += delta
		var secs = int(time) % 60
		var mins = int(time / 60) % 60

		set_counter(mins, secs)

		if mins > 0 and !(secs % 30):
			DIST = (DIST + 1) as LOBBY.DIST
			if isHosting: find_match()

	else: _error(TIMEOUT)


# Matchmaking Functions ------------------------------------------------------------------------- #

var isHosting = false

func find_match():
	LOBBY._leave()
	LOBBY.request_lobbies(MODE, DIST)
	isHosting = false

func host_match(): 
	LOBBY._leave()
	LOBBY.host_lobby(MODE, TYPE)
	isHosting = true


func match_hosted(status: int, msg: String):
	if status == 1: _play(msg)
	else: _error(msg)

func match_joined(success: bool, msg: String):
	if success: _play(msg)
	else: _error(msg)


func matchmaking(lobbies: Array):

	if lobbies.size() > 0:

		for id in lobbies:
			LOBBY._debug(id)
			if id != LOBBY.ID:
				LOBBY.join_lobby(lobbies[0])
				return

	else: host_match()
