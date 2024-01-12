extends "res://Game/_Classes/Setup.gd"

@onready var Landing = $Landing
@onready var Blockade = $Blockade

var ownScript = load("res://Game/Units/Scripts/Own.gd")
var foeScript = load("res://Game/Units/Scripts/Foe.gd")


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	SPECS = Vector2(8, 9)
	ARRAY = null_matrix(SPECS.x, SPECS.y)
	if not USER.HOSTING:
		offset_landing()
	toggle_landing(true)


# In-game Functions ----------------------------------------------------------------------------- #

func game_play():
	toggle_landing(false)
	ready_allies()
	place_enemies()

func game_over(): pass


# Setup Functions ------------------------------------------------------------------------------- #

func setup_reset():
	reset_map()
	reset_arr()
	setup_ready(false)

func setup_ready(val: bool):

	var FORM = ""

	if val:

		var START = 0
		if not USER.HOSTING: START = 5

		for r in range(START, START + 3):
			for c in range(SPECS.y):
				var type = 0
				var unit = ARRAY[r][c]
				if unit != null:
					type = unit.TYPE
				FORM += str(type)
			FORM += "-"

		FORM = FORM.left(FORM.length() - 1)

	Steam.setLobbyMemberData(LOBBY.ID, "form", FORM)


# Landing Area Functions for Drag-&-Drop -------------------------------------------------------- #

func offset_landing():

	var offset1 = tileSize.y * 5
	var offset2 = -(tileSize.y * 3)

	Landing.move_local_y(offset1)
	Blockade.move_local_y(offset2)


func toggle_landing(val: bool) -> void:

	Landing.disabled = !val
	Tiles.collision_use_parent = !val

	var color = Blockade.modulate
	if val: color.a = 1
	else: color.a = 0

	var tween = Blockade.create_tween()
	tween.tween_property(Blockade, "modulate", color, 0.3)


# Rescript Ally Units --------------------------------------------------------------------------- #

func ready_allies():
	
	var allies = get_tree().get_nodes_in_group("Allies")

	for ally in allies:

		var type = ally.TYPE
		var team = ally.TEAM
		var dir = ally.DIR

		ally._start()
		ally.set_script(ownScript)

		ally.set_type(type)
		ally.set_team(team)
		ally.set_dir(dir)
		ally._ready()

func clear_enemies():
	var enemies = get_tree().get_nodes_in_group("Foes")
	for enemy in enemies: enemy.queue_free()


# Make Enemy Units ------------------------------------------------------------------------------ #

func place_enemies():

	var rOFF = 0
	if USER.HOSTING: rOFF = 5

	var FORM = LOBBY.MEMBERS[P2P.ENEMY]["form"].split("-")

	for r in range(FORM.size()):
		var ROW = FORM[r]
		for c in range(ROW.length()):
			var type = int(ROW[c])
			if type:
				make_enemy(type, r + rOFF , c)
				await get_tree().create_timer(0.2).timeout


const MINIMIZED = Vector2(0.1, 0.1)
const NORMALIZE = Vector2(1.0, 1.0)
func make_enemy(type: int, x: int, y: int):

	var unit = unitScene.instantiate()
	unit.set_script(foeScript)
	unit.scale = MINIMIZED
	Tiles.add_child(unit)

	unit.set_type(-type)
	if USER.HOSTING: unit.swap_team()

	unit.position = get_grid_pos(x, y)
	ARRAY[x][y] = unit

	var tween = unit.create_tween()
	tween.tween_property(unit, "scale", NORMALIZE, 0.15)
	await tween.finished
