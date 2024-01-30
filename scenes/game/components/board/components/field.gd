extends Grid
class_name Field
## The actual [b]battlefield[\b] to be played on, where
## [Unit]s of either [Ally] or [Enemy] classes [b]play[\b] the [Game] proper.


# Pre-loaded Scenes
var UNIT := preload('res://scenes/game/components/unit/unit.tscn')
var ALLY := preload('res://scenes/game/components/unit/scripts/ally.gd')
var ENEMY := preload('res://scenes/game/components/unit/scripts/enemy.gd')


# Member Scenes
@onready var SET: TileSet = tile_set
@onready var CELL = SET.tile_size
@onready var HALF = CELL / 2


# Core Functions ------------------------------------------------------------- #

## Connects relevant [SIGNALS].
func _ready():
	SIGNALS.game_start.connect(_start)
	SIGNALS.game_reset.connect(_reset)


## Places the [Enemy] [Unit]s and [method Field.lighten]s the layer modulation.
func _start():
	form_enemies()
	lighten()


## Clears the [member Grid.GRID] and children of the [TileMap].
func _reset():
	clear_map()
	clear_cells()


## [TODO] Unsure.
func _setup(_val: bool): pass


# Unit Deletion -------------------------------------------------------------- #

## Removes all child [Units] from the [TileMap] proper.
func clear_map():
	for unit in get_children():
		remove_child(unit)
		unit.queue_free()


## Removes all child [Enemy] [Units] from the [TileMap] proper.
func clear_enemies():
	for enemy in get_tree().get_nodes_in_group(Unit.GROUPS.ENEMY):
		remove_child(enemy)
		enemy.queue_free()


# Unit Creation -------------------------------------------------------------- #

## Creates and places [Ally] [Unit]s,
## using [method Unit.copy] to clone its attributes.
func make_ally(unit: Unit):

	var ally := UNIT.instantiate()
	ally.set_script(ALLY)
	add_child(ally)

	#ally.copy(unit)

	var cell := local_to_map(unit.position)
	snap_to(cell, ally)
	ally.copy(unit)


## Creates and places [Enemy] [Unit]s given the supplied parameters.
func make_enemy(cell: Vector2i, type: int, team: Unit.TEAMS):

	var enemy := UNIT.instantiate()
	enemy.set_script(ENEMY)
	enemy.set_team(team)
	enemy.set_type(type)

	add_child(enemy)
	snap_to(cell, enemy)


# Formation ------------------------------------------------------------------ #

## [TODO] Converts the [member P2P.ENEMY]'s [member ROOM.Member.form]
## into a [member Grid.GRID] composed of [Enemy] [Unit]s.
func form_enemies():

	# [TODO] Create a function to automatically do the below.
	#var form := ROOM.get_form(P2P.ENEMY)
	#var FORM = ROOM.MEMBERS[P2P.ENEMY][LOBBY.META.FORM].split("-")

	var team := Unit.TEAMS.BLACK
	if USER.HOSTING: team = Unit.TEAMS.WHITE
	
	#for r in range(form.size()):
		#var row := form[r]
		#for c in range(row.length()):
			#var type := int(row[c])
			#if type:
				#var cell  Vector2i(r, c)
				#make_enemy(cell, type, team)
				#await get_tree().create_timer(0.2).timeout
