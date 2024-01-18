extends Field

const UNIT = preload("res://scenes/game/components/unit/unit.tscn")
const OWN_UNIT = preload("res://scenes/game/components/unit/scripts/own.gd")
const FOE_UNIT = preload("res://scenes/game/components/unit/scripts/foe.gd")


func setup_finished():
	end_setup(true)

func end_setup(val: bool):

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
	

func game_play():
	ready_allies()
	place_enemies()



# Rescript Ally Units --------------------------------------------------------------------------- #

func ready_allies():
	
	var allies = get_tree().get_nodes_in_group("Allies")

	for ally in allies:

		var type = ally.TYPE
		var team = ally.TEAM
		var dir = ally.DIR

		ally._start()
		ally.set_script(OWN_UNIT)

		ally.set_type(type)
		ally.set_team(team)
		ally.set_dir(dir)
		ally._ready()

func clear_enemies():
	var enemies = get_tree().get_nodes_in_group("Foes")
	for enemy in enemies: enemy.queue_free()


# Enemy Placement ------------------------------------------------------------------------------- #

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

	var unit = UNIT.instantiate()
	unit.set_script(FOE_UNIT)
	unit.scale = MINIMIZED
	add_child(unit)

	unit.set_type(-type)
	if USER.HOSTING: unit.swap_team()

	unit.position = get_grid_pos(x, y)
	ARRAY[x][y] = unit

	var tween = unit.create_tween()
	tween.tween_property(unit, "scale", NORMALIZE, 0.15)
	await tween.finished
