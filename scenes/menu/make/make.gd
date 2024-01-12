extends MarginContainer

const Game = "res://Game/Game.tscn"
const MODE = LOBBY.MODE.MANUAL
const DIST = LOBBY.DIST.GLOBAL

@onready var Lobbies = $"%Lobbies"
var LobbyButton = preload("res://scenes/menu/make/lobby_button/lobby_button.tscn")

@onready var HostType = $"%HostType"
@onready var HostName = $"%HostName"
@onready var FindName = $"%FindName"
@onready var FindButt = $"%FindButt"
@onready var Cancel = $"%Cancel"


# Basic Funtions -------------------------------------------------------------------------------- #

func _ready():
	for item in LOBBY.TYPE:
		HostType.add_item(item, LOBBY.TYPE[item])
	HostType.select(LOBBY.TYPE.PUBLIC)

func _start():
	HostName.grab_focus()
	SIGNALS.connect("host_success", Callable(self, "room_hosted"))
	SIGNALS.connect("join_success", Callable(self, "room_joined"))
	SIGNALS.connect("find_lobbies", Callable(self, "list_rooms"))
	find_rooms()
	
func _reset():
	SIGNALS.disconnect("host_success", Callable(self, "room_hosted"))
	SIGNALS.disconnect("join_success", Callable(self, "room_joined"))
	SIGNALS.disconnect("find_lobbies", Callable(self, "list_rooms"))
	LOBBY._leave()


# Signaling Functions --------------------------------------------------------------------------- #

func _play(msg: String): SIGNALS.emit_signal("play", msg)
func _error(msg: String): SIGNALS.emit_signal("warning", msg)


# Custom Functions ------------------------------------------------------------------------------ #

func host_room():
	if HostName.text:
		var NAME = HostName.text
		var TYPE = HostType.get_selected_id()
		LOBBY.host_lobby(MODE, TYPE, NAME)

func find_rooms():
	var NAME = FindName.text.strip_edges()
	LOBBY.request_lobbies(MODE, DIST, NAME)


# Signals & Connections ------------------------------------------------------------------------- #

func room_hosted(success: bool, msg: String):
	if success: _play(msg)
	else: _error(msg)


func room_joined(success: bool, msg: String):
	if success: _play(msg)
	else: _error(msg)


func list_rooms(lobbies: Array):

	for child in Lobbies.get_children(): child.queue_free()

	# Set default Focus Mapping
	if !lobbies.size():
		refocus_find(Cancel)
		refocus_prev(Cancel, FindButt)

	else:

		var i = -1
		for id in lobbies:

			var button = LobbyButton.instantiate()
			button.name = "LobbyButton_%d" % i
			Lobbies.add_child(button)

			button.set_name(Steam.getLobbyData(id, "name"))
			button.set_host(Steam.getLobbyData(id, "host"))
			button.set_id(id)

			if i < 0:
				refocus_find(button)
				refocus_prev(button, FindButt)

			else:
				var prev = Lobbies.get_child(i)
				refocus_next(prev, button)
				refocus_prev(button, prev)

			refocus_side(button)
			refocus_next(button, Cancel)
			refocus_prev(Cancel, button)
			i += 1


# Focus Mapping for Inputs ---------------------------------------------------------------------- #

func refocus_find(node: Control = Cancel):
	node = get_target(node)
	var path = node.get_path()
	FindButt.focus_neighbor_bottom = path
	FindName.focus_neighbor_bottom = path
	FindButt.focus_next = path
	

func refocus_side(node: Control):
	node = get_target(node)
	var path = node.get_path()
	node.focus_neighbor_left = path
	node.focus_neighbor_right = path

func refocus_next(node: Control, next: Control):
	node = get_target(node)
	next = get_target(next)
	var path = next.get_path()
	node.focus_neighbor_bottom = path
	node.focus_next = path

func refocus_prev(node: Control, prev: Control):
	node = get_target(node)
	prev = get_target(prev)
	var path = prev.get_path()
	node.focus_neighbor_top = path
	node.focus_previous = path


func get_target(node: Control):
	if "LobbyButton_" in node.name:
		node = node.get_node("Name")
	return node
