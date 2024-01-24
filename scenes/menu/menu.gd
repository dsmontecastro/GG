extends Control
class_name Menu
## [Menu]-Controller class, used to control its multiple children components.

# Member Scenes
@onready var FIND: FindScreen = $Find
@onready var MAIN: MainScreen = $Main
@onready var MAKE: MakeScreen = $Make
@onready var OPTS: OptsScreen = $Opts


# Core Functions ------------------------------------------------------------- #

func _ready():
	SIGNALS.menu_play.connect(_play)
	SIGNALS.menu_reset.connect(_reset)
	P2P._reset()
	_start()


## Applies the [method Screen._start] function for all [Screens].
func _start():
	for screen in get_tree().get_nodes_in_group('Screens'):
		screen._start()


## Applies the [method Screen._reset] function for all [Screens].
func _reset():
	for screen in get_tree().get_nodes_in_group('Screens'):
		screen._reset()


## Starts the [Game] proper, along with a [param message] for debugging.
func _play(msg: String):
	print(msg)
	print(LOBBY._debug() + '\n')
	LOADER.load_to(LOADER.SCENE_NAMES.GAME)


## [TEST] For debugging; skips the matchmaking processes and starts the [Game].
func _test(): SIGNALS.menu_play.emit('DEBUG')


#  Screen Transitions -------------------------------------------------------- #

## Tracks the current "active" [Screen]
@onready var ACTIVE: Screen = MAIN


## Toggles the [Find] [Screen].
func find(): FIND._start()


## Transitions to or from the [Make] [Screen].
func toggle_make():
	if ACTIVE == MAKE:
		MAKE.slideL()
		MAIN.slideL()
		ACTIVE = MAIN
	else:
		MAIN.slideR()
		MAKE.slideR()
		MAKE._start()
		ACTIVE = MAKE


## Transitions to or from the [Opts] [Screen].
func toggle_opts():
	if ACTIVE == OPTS:
		OPTS.slideR()
		MAIN.slideR()
		ACTIVE = MAIN
	else:
		MAIN.slideL()
		OPTS.slideL()
		OPTS._start()
		ACTIVE = OPTS
