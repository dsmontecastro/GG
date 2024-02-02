extends Area2D
class_name Unit
## Base-Class for all [Unit] subclasses.[br]
## Contains common properties and methods that are to be inherited.[br]


# Enumerations
enum TEAMS { BLACK = -1, NONE = 0, WHITE = 1 }

# Constants
const TYPES = 16
const CLICK = 'Click'
const GROUPS := {
	UNIT = 'Unit',
	DRAG = 'Drag',
	ALLY = 'Ally',
	ENEMY = 'Enemy',
}

# Exports
@export_range(0, TYPES) var TYPE := 0	## Ranges from 0 to [enum Unit.TYPES].
@export var TEAM := TEAMS.NONE			## Choose from [enum Unit.TEAMS].

# Member Senes
@onready var AREA: CollisionShape2D = $Area
@onready var ANIM: AnimatedSprite2D = $Anim
@onready var DEATH: AnimatedSprite2D = $Death
@onready var FILTER: ColorRect = $Filter
@onready var MOVES: TileMap = $Moves


# Core Functions ------------------------------------------------------------- #

## 
func _ready():
	self.mouse_entered.connect(mouse_in)
	self.mouse_exited.connect(mouse_out)
	add_to_group(GROUPS.UNIT, true)
	swap_team(TEAM)
	set_type(TYPE)


## 
func _start(): pass


## Re-sets the necessary paramters, generally after a [b]script change[\b],
func _reset():
	set_type(TYPE)
	set_team(TEAM)
	if TEAM == TEAMS.BLACK: swap_team()
	#rescale(NORMAL)


# Type & Team Configuration -------------------------------------------------- #

## Dedicated setter for [member Unit.TYPE].
func set_type(type: int):
	TYPE = clamp(type, 0, TYPES)
	swap_anim(type)


## Dedicated setter for [member Unit.TEAM].
func set_team(team: TEAMS):
	TEAM = team
	swap_team(team)


# Mouse Inputs --------------------------------------------------------------- #

## Triggered when the [b]mouse[\b] enters the [Unit]'s [member Unit.AREA].
func mouse_in():
	rescale(SCALE.BIG)
	play()


## Triggered when the [b]mouse[\b] leaves the [Unit]'s [member Unit.AREA].
func mouse_out():
	rescale(SCALE.DEF)
	stop()


## Triggers the [member Unit.AREA] functionality and interactability.
func mouse_toggle(val: bool):
	input_pickable = val
	monitorable = val
	monitoring = val


# ANIM Scale ----------------------------------------------------------------- #

## Pre-set Scale Values
const SCALE = {
	DEF = Vector2(0.13, 0.13),
	BIG = Vector2(0.15, 0.15),
}


## Changes the [b]scale[/b] of the [member Unit.ANIM] sprites.
func rescale(val: Vector2):
	var tween = create_tween()
	tween.tween_property(ANIM, 'scale', val, 0.25)


# ANIM Color  ---------------------------------------------------------------- #

## Material containing a [i]shader[/i] used to [b]invert[/b] colors beneath it.
@onready var INVERTER := load('res://assets/shaders/invert/invert.material')


## Toggles the [b]color[/b] of the [member Unit.ANIM] sprites.
func swap_color(team: TEAMS = TEAM):

	if team == TEAMS.BLACK:
		ANIM.set_material(INVERTER)
		set_orientation(PI)

	else:
		ANIM.set_material(null)
		set_orientation(0)


## Toggles the [b]team[/b] of the [member Unit.ANIM] sprites.
func swap_team(team: TEAMS = TEAMS.NONE):

	if team == TEAMS.NONE:
		team = (TEAM * -1) as TEAMS

	if TEAM != team: swap_color(team)


# ANIM Animation ------------------------------------------------------------- #

## Swaps to the matching animation given the provided [param index].
func swap_anim(index: int):
	ANIM.animation = '%02d' % index
	ANIM.stop()


## Plays the current animation assigned to [member Unit.ANIM].
func play():
	if TYPE > 0:
		ANIM.frame = 0
		ANIM.play()


## Stops the current animation [member Unit.ANIM], and restarts from frame 0.
func stop():
	if TYPE > 0:
		ANIM.stop()
		ANIM.frame = 0


# ANIM Orientation ----------------------------------------------------------- #

## Tracker for the current orientation of [member Unit.ANIM].
var ORIENTATION := 0.0


## Dedicated setter for [member Unit.TEAM].
func set_orientation(orientation: float):
	ORIENTATION = orientation
	orient_to(orientation)


## Instantly orients the [member Unit.ANIM] to the given [param orientation].
func orient_to(orientation: float):
	ANIM.global_rotation = orientation


## Spins the [member Unit.ANIM] to the given [param orientation].
func spin_to(orientation: float = ORIENTATION):

	if abs(orientation - ANIM.global_rotation) > PI:
		orientation += 2 * PI

	var tween = ANIM.create_tween()
	tween.tween_property(ANIM, 'global_rotation', orientation, 0.25)
