extends "res://Game/_Classes/Setup.gd"

var dragScript = load("res://Game/Units/Scripts/Drag.gd")
@onready var Ready = $"%Ready"
@onready var Reset = $"%Reset"


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	SPECS = Vector2(len(ORDER), len(ORDER[0]))
	ARRAY = null_matrix(SPECS.x, SPECS.y)
	Tiles.collision_use_parent = true
	reset_arr()


# In-game Functions ----------------------------------------------------------------------------- #

func game_play():
	self.hide()

func game_over():
	self.show()


# Setup Functions ------------------------------------------------------------------------------- #

func reset_pressed(): SIGNALS.emit_signal("setup_reset")

func ready_toggled(val: bool):
	if is_clear(): SIGNALS.emit_signal("setup_ready", val)
	else: Ready.set_pressed_no_signal(false)


func setup_reset():
	Ready.set_pressed_no_signal(false)
	reset_map()
	reset_arr()

func setup_ready(val: bool):

	var alpha = 1.0
	if val: alpha = 0.5

	var tween = Tiles.create_tween()
	tween.tween_property(Tiles, "modulate:a", alpha, 0.25)


# Reset Grid Array ------------------------------------------------------------------------------ #

const ORDER = [
			[01, 02, 04, 10],
			[03, 02, 05, 11],
			[00, 02, 06, 12],
			[00, 02, 07, 13],
			[00, 02, 08, 14],
			[15, 02, 09, 15]]


func reset_arr():
	for r in range(SPECS.x):
		for c in range(SPECS.y):
			var type = ORDER[r][c]
			if type: make_ally(type, r, c)
			else: ARRAY[r][c] = null


func make_ally(type: int, x: int, y: int):

	var ally = unitScene.instantiate()
	ally.set_script(dragScript)
	Tiles.add_child(ally)

	ally.set_type(type)
	if not USER.HOSTING: ally.swap_team()

	var pos = get_grid_pos(x, y)
	ally.originate(pos, self)
	ARRAY[x][y] = ally
