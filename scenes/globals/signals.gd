extends Node
## Globally handles all signals used in connections and emissions.


# Globals -------------------------------------------------------------------- #

signal error(message: String)	## A message has been forwarded to [Error].
#signal reset					## @deprecated: Unused at the moment.


# Room and Lobbies ----------------------------------------------------------- #

signal data_update(success: bool, message: String)		## The [ROOM] metadata has been updated.
signal users_update(state: int, message: String)		## A [class ROOM.Member] has joined or left.
signal found_lobbies(lobbies: Array)					## The [Steam] [param lobbies] have been updated.

signal host_response(success: bool, message: String)	## Response to a [b]hosting[/b] request.
signal join_response(success: bool, message: String)	## Response to a [b]join[/b] request.


# Loader --------------------------------------------------------------------- #

signal loader_covered				## [LoaderAnim] has covered the screen.
signal loading_scene(val: bool)		## [LOADER] state has started or finished processing a scene.


# Messaging ------------------------------------------------------------------ #

#signal send		## 
#signal read		## 


# Menu ---------------------------------------------------------------------- #

signal menu_reset(message: String)	## Reset the [Menu] and its components.
signal menu_play(message: String)	## Transition from [Menu] to [Game].


# Game Setup ----------------------------------------------------------------- #

signal game_reset(base: String)		## Resets relevant [Game] components.
signal game_setup(val: bool)		## Signals that [USER] is ready.
signal game_ready(val: bool)		## Verifies that [USER] if actually ready.
signal game_start					## Attempts to start the [Game] proper.

## Drags a [Draggable] to the given [param pos], if valid.
## Attemps to [method Draggable.drag] a [Unit] to a [param position].
signal drag_to(unit: Draggable, pos: Vector2)


# Game Proper ---------------------------------------------------------------- #

signal swap_turn(val)					## [TODO]
signal game_over(win)					## [TODO]
signal forfeit							## [TODO]


# Unit ----------------------------------------------------------------------- #

signal move(unit: Unit, pos: Vector2)	## [TODO]
signal has_moved						## [TODO]
signal has_died							## [TODO]
