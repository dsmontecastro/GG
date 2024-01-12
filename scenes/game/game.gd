extends Node2D

@onready var Board = $Board
@onready var Tiles = $Board/Tiles

@onready var Side = $Sidebar
@onready var Setup = $Sidebar/Setup


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	SIGNALS.connect("drop", Callable(self, "drop_unit"))
	SIGNALS.connect("game_play", Callable(self, "game_play"))
	SIGNALS.connect("game_over", Callable(self, "game_over"))
	SIGNALS.connect("swap_turn", Callable(self, "swap_turn"))
	SIGNALS.connect("setup_reset", Callable(self, "setup_reset"))
	SIGNALS.connect("setup_ready", Callable(self, "setup_ready"))
	LOBBY.connect("lobby_update", Callable(self, "lobby_change"))
	P2P._start()


# In-game Functions ----------------------------------------------------------------------------- #

func game_play():

	P2P.send(P2P.MSSG.ALL_READY)
	USER.IN_GAME = true

	Side.game_play()
	Setup.game_play()
	Board.game_play()
	Board.game_proper()


func game_over(win: bool):

	USER.IN_GAME = false
	USER.IS_TURN = !win
	setup_reset()

	print("GAME OVER!")
	if win: print("WINNER!")
	else: print("LOSER...")


# State-changes --------------------------------------------------------------------------------- #

func swap_turn(val: bool):
	if !val: P2P.send(P2P.MSSG.SWAP_TURN, !val)
	Side.swap_turn(val)
	USER.IS_TURN = val


func lobby_change(state: int, _msg: String):

	P2P._start()

	# Player Left/Kicked/Banned
	if state > 1:

		if USER.IN_GAME:
			USER.IN_GAME = false
			SIGNALS.emit_signal("setup_reset")
		else: Board.clear_enemies()

		if not USER.HOSTING: USER.HOSTING = true

	Side.update_profiles()


# Setup Functions ------------------------------------------------------------------------------- #

func setup_reset():
	USER.READIED = false
	Setup.setup_reset()
	Board.setup_reset()

func setup_ready(val: bool):

	P2P._start()
	USER.READIED = val
	Setup.setup_ready(val)
	Board.setup_ready(val)

	if val and LOBBY.all_ready():
		P2P.send(P2P.MSSG.PLAY_GAME)
		await SIGNALS.all_ready
		SIGNALS.emit_signal("game_play")


# P2P Parsing  ---------------------------------------------------------------------------------- #

func _process(_d):
	var data = P2P.read()
	if not data.is_empty(): _parse(data)

func _parse(data: Dictionary):

	print("Received: ", data)

	var msg = data["msg"]
	var val = data["val"]

	match msg:

		P2P.MSSG.ALL_READY: SIGNALS.emit_signal("all_ready")
		P2P.MSSG.SWAP_TURN: SIGNALS.emit_signal("set_turn", val)

		P2P.MSSG.GAME_OVER: game_over(val)
		P2P.MSSG.PLAY_GAME: game_play()

		P2P.MSSG.KILL_UNIT: Board.kill_unit(val)
		P2P.MSSG.MOVE_UNIT: Board.move_unit(val[0], val[1])


# Drag-&-Drop ----------------------------------------------------------------------------------- #

func drop_unit(unit: Area2D, move: Vector2):
	
	var fromTile = unit.get_parent()
	var fromArea = fromTile.get_parent()
	var fromPos = fromTile.to_local(unit.ORIGIN)

	var currArea = unit.currArea
	var currTile = currArea.Tiles
	var currPos = currTile.to_local(move)

	var from = fromTile.local_to_map(fromPos)
	move = currTile.local_to_map(currPos)
	move.x = clamp(move.x, 0, currArea.SPECS.y - 1)
	move.y = clamp(move.y, 0, currArea.SPECS.x - 1)

	if currArea.is_empty(move.x, move.y):

		if currArea != fromArea:
			fromTile.remove_child(unit)
			currTile.add_child(unit)

		fromArea.ARRAY[from.y][from.x] = null
		currArea.ARRAY[move.y][move.x] = unit
		unit.drop_unit(move)

	else: unit._reset()
