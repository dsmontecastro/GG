extends Node2D
class_name Board
## Core [Board] class, used control its children [Base] and [Field] components.
## This section contains the common class members and methods.


# Member Scenes
@onready var FIELD: Field = $Field
@onready var FOE: Base = $Black if USER.HOSTING else $White		## Foe's [Base]
@onready var OWN: Base = $White if USER.HOSTING else $Black		## User's [Base]

# Trackers
@onready var UNIT_COUNT := OWN.get_child_count()


# Core Functions ------------------------------------------------------------- #

## Connects [SIGNALS] and changes 
func _ready():
	Steam.lobby_chat_update.connect(user_update)
	SIGNALS.game_readied.connect(_readied)
	SIGNALS.game_setup.connect(_setup)
	SIGNALS.game_start.connect(_start)
	_reset()


## On [signal SIGNALS.game_start], hides the [Base]s
## and disables irrelevant [signal]s.
func _start():
	SIGNALS.game_readied.disconnect(_readied)
	SIGNALS.game_setup.disconnect(_setup)
	SIGNALS.game_start.disconnect(_start)
	OWN._start()
	FOE._start()


## [TODO] Decide whether to controls signals from here,
## or directly connect them to the components.
func _reset():
	OWN._reset()
	if USER.IN_GAME:
		FOE._reset()


## Copies the [Unit]s in [member Board.OWN] to [member Board.FIELD].[br]
## Afterwards, updates the [USER]'s [class ROOM.Member] dat
## in [member ROOM.MEMBERS].
func _setup(val: bool):
	if val and OWN.cleared():

		for child: Draggable in OWN.get_children():
			FIELD.make_ally(child)
		FIELD.update_cells()

		var form := FIELD.get_form()
		LOBBY.setup(form)


## [TODO] Unsure
func _readied(ready: bool):
	if ready: pass


## [TODO] Untested
func user_update(_id: int, _flag: int): pass
	#update_members()
