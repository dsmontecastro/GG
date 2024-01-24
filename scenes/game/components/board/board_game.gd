extends Board_Setup
#class_name Board_Game
## This section contains the game-related members and methods.

#var OWN_BASE = 0
#var FOE_BASE = SPECS.x - 1
#
#
## Gameplay Functions ---------------------------------------------------------------------------- #
#
#func game_proper():
	#SIGNALS.connect(SIGNALS.GAME.MOVE, Callable(self, "process_move"))
	#SIGNALS.connect(SIGNALS.GAME.OVER, Callable(self, "_over"))
#
## Move Processing ------------------------------------------------------------------------------- #
#
#func end_turn(): SIGNALS.emit_signal("swap_turn", false)
#
#func is_valid_move(to: Vector2) -> bool:
	#return to.y in range(SPECS.x) and to.x in range(SPECS.y)
#
#func process_move(from: Vector2, move: Vector2):
#
	#move += from
	#var unit = ARRAY[from.y][from.x]
	#var cell = ARRAY[move.y][move.x]
#
#
	## Unit moves to free-space
	#if cell == null:
		#move_unit(from, move, true)
		#end_turn()
#
	## Unit confronts Enemy
	#elif unit.TEAM != cell.TEAM:
#
		#var u = unit.TYPE
		#var c = abs(cell.TYPE)
#
		## Unit Loss
		#if (u == 15 and c == 2) or (u < c and not (u == 2 and c == 15)):
#
			#kill_unit(from, true)
			#await SIGNALS.done_killing
#
			#if u == 1: SIGNALS.emit_signal("game_over", false)
			#else: end_turn()
#
#
		#else:	# Unit Win
#
			#kill_unit(move, true)
			#await SIGNALS.done_killing
#
			#move_unit(from, move, true)
			#await SIGNALS.done_moving
#
			#if c == 1: SIGNALS.emit_signal("game_over", true)
			#else: end_turn()
#
#
## Unit-based Functions -------------------------------------------------------------------------- #
#
#func kill_unit(pos: Vector2, send: bool = false):
#
	#if send: P2P.send(P2P.MSSG.KILL_UNIT, pos)
#
	#var unit = ARRAY[pos.y][pos.x]
	#ARRAY[pos.y][pos.x] = null
	#unit.die()
#
#
#func move_unit(from: Vector2, move: Vector2, send: bool = false):
#
	#if send: P2P.send(P2P.MSSG.MOVE_UNIT, [from, move])
#
	#var unit = ARRAY[from.y][from.x]
	#ARRAY[from.y][from.x] = null
	#ARRAY[move.y][move.x] = unit
	#unit.move(move)
#
	#await SIGNALS.done_moving
#
#
	## Flag moves to Opposite End
	#var type = unit.TYPE
#
	#if type == 1 and move.y == FOE_BASE:
		#SIGNALS.emit_signal("game_over", true)
#
	#elif type == -1 and move.y == OWN_BASE:
		#SIGNALS.emit_signal("game_over", false)
