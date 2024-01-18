extends Node


# Global -------------------------------------------------------------------- #

const NODE = {
	WARN = "warning",
	RESET = "reset"
}

signal warning(message)
signal reset


# Lobby --------------------------------------------------------------------- #

const ROOMS = {
	DATA = "data_update",
	LOBB = "lobby_update",
	FIND = "find_lobbies",
	HOST = "host_success",
	JOIN = "join_success"
}

signal data_update(success, message)
signal lobby_update(state, message)
signal find_lobbies(lobbies)
signal host_success(val, message)
signal join_success(val, message)


# Menu ---------------------------------------------------------------------- #

const MENU = {
	PLAY = "play",
	OPTS = "exit_opts"
}

signal play(message)
signal exit_opts


# Game Signals -------------------------------------------------------------- #

signal send
signal read


# Game Setup ---------------------------------------------------------------- #

const SETUP = {
	FINISH = "setup_finished",
	RESET = "setup_reset",
	READY = "setup_ready",
	START = "all_ready"
}

signal setup_reset
signal setup_ready(val)
signal setup_finished
signal all_ready


# Game Proper --------------------------------------------------------------- #

const GAME = {
	START = "game_start",
	OVER = "game_over",
	SWAP = "swap_turn",
	MOVE = "move",
	MOVED = "move_done",
	KILLED = "kill_done"
}

signal game_start
signal game_over(win)
signal swap_turn(val)

signal move()
signal move_done
signal kill_done
