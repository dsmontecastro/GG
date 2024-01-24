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

signal loading_covered				## [LoaderAnim] has covered the screen.
signal loading_scene(val: bool)		## [LOADER] state has started or finished processing a scene.


# Messaging ------------------------------------------------------------------ #

#signal send		## 
#signal read		## 


# Menu ---------------------------------------------------------------------- #

signal menu_reset(message: String)	## Reset the [Menu] and its components.
signal menu_play(message: String)	## Transition from [Menu] to [Game].


# Game Setup ---------------------------------------------------------------- #

signal setup_reset			## [TODO]
signal setup_ready(val)		## [TODO]
signal setup_finished		## [TODO]
signal all_ready			## [TODO]


# Game Proper --------------------------------------------------------------- #

signal game_play		## [TODO]
signal game_over(win)	## [TODO]
signal swap_turn(val)	## [TODO]

signal move()			## [TODO]
signal move_done		## [TODO]
signal kill_done		## [TODO]
