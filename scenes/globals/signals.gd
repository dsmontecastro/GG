extends Node
## Globally handles all signals used in connections and emissions.


# Globals -------------------------------------------------------------------- #

signal error(message: String)	## A message has been forwarded to [Error].
#signal reset					## @deprecated: Unused at the moment.


# Room and Lobbies ----------------------------------------------------------- #

signal data_update(success: bool, message: String)		## The [ROOM] metadata has been updated.
signal users_update(state, message: String)				## A [class ROOM.Member] has joined or left the [ROOM].
signal found_lobbies(lobbies: Array)					## The lost of [param lobbies] has been updated.

signal host_response(success: bool, message: String)	## Response to a [b]hosting[/b] request.
signal join_response(success: bool, message: String)	## Response to a [b]join[/b] request.


# Messaging ------------------------------------------------------------------ #

#signal send		## 
#signal read		## 


# Menu ---------------------------------------------------------------------- #

#signal menu_reset(message: String)	## @deprecated: Unused at the moment.
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
