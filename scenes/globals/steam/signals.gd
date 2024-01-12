extends Node


# Global -------------------------------------------------------------------- #

signal warning(message)
signal reset


# Lobby --------------------------------------------------------------------- #

signal data_update(success, message)
signal lobby_update(state, message)
signal find_lobbies(lobbies)
signal host_success(val, message)
signal join_success(val, message)


# Menu ---------------------------------------------------------------------- #

signal play(message)
signal exit_opts


# Game Signals -------------------------------------------------------------- #

signal send
signal read


# Game Setup ---------------------------------------------------------------- #

signal setup_reset
signal setup_ready(val)
signal setup_finished

signal all_ready


# Game Proper --------------------------------------------------------------- #

signal game_play
signal game_over(win)
signal swap_turn(val)

signal move()	# During Game Proper
signal drop()	# During Setup

signal done_killing
signal done_moving
