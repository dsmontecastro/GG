extends Area2D
class_name Unit
##


# Enumerations
enum TEAMS { BLACK = -1, NONE = 0, WHITE = 1 }

# Constants
const TYPES = 16
const GROUPS := {
	UNIT = 'Unit',
	ALLY = 'Ally',
	ENEMY = 'Enemy',
}

# Exports
@export_range(0, TYPES) var TYPE := 0	## Ranges from 0 to [enum Unit.TYPES].
@export var TEAM := TEAMS.NONE			## Choose from [enum Unit.TEAMS].

# Member Senes
@onready var AREA: CollisionShape2D = $Area
@onready var ANIM: AnimatedSprite2D = $Anim
@onready var KILL: AnimatedSprite2D = $Kill
@onready var FILTERS: Node2D = $Filters
@onready var MOVES: TileMap = $Moves


# Core Functions ------------------------------------------------------------- #

func _ready():
	self.mouse_entered.connect(mouse_in)
	self.mouse_exited.connect(mouse_out)
	add_to_group(GROUPS.UNIT, true)
	swap_team(TEAM)
	set_type(TYPE)

func _start(): pass

func _reset():
	set_type(TYPE)
	set_team(TEAM)
	if TEAM == TEAMS.BLACK: swap_team()
	rescale(NORMAL)


# Type & Team Configuration -------------------------------------------------- #

## 
func set_type(val: int):
	TYPE = clamp(val, 0, TYPES)
	swap_anim(val)


## 
func set_team(team: TEAMS): TEAM = team


## 
func swap_team(team: TEAMS = TEAMS.NONE):

	if TEAM != TEAMS.NONE:
		TEAM = (TEAM * -1) as TEAMS
		swap_color()
		if TYPE > 1: set_dir(PI)

	else:
		TEAM = team
		if team == TEAMS.BLACK: swap_color()


func copy(unit: Unit):
	set_type(unit.TYPE)
	set_team(unit.TEAM)


const invertModulate = Color(0.25, 0.25, 0.25)	# Matches BOARD Color
var invertMaterial = load('res://assets/shaders/invert/invert.material')

func swap_color():
	ANIM.material = invertMaterial
	ANIM.modulate = invertModulate
	#ANIM.visible = true


# Mouse Inputs --------------------------------------------------------------- #

func mouse_in():
	rescale(BIGGER)
	play_anim()

func mouse_out():
	rescale(NORMAL)
	exit_anim()

func mouse_toggle(val: bool):
	input_pickable = val
	monitorable = val
	monitoring = val


# Scale Pop Tweening ---------------------------------------------------------------------------- #

const NORMAL = Vector2(0.1, 0.1)
const BIGGER = NORMAL * 1.1

func rescale(val: Vector2):
	var tween = create_tween()
	tween.tween_property(ANIM, 'scale', val, 0.25)


# Animation Controls (Media) -------------------------------------------------------------------- #

func swap_anim(val: int):
	ANIM.animation = '%02dA' % val
	ANIM.stop()

func play_anim():
	if TYPE > 0:
		var anim := ANIM.animation
		anim.replace('B', 'A')
		ANIM.play(anim)

func exit_anim():
	if TYPE > 0:
		var anim := ANIM.animation
		anim.replace('A', 'B')
		ANIM.play(anim)


# Animation Controls (Direction) ---------------------------------------------------------------- #

var DIR = 0

func set_dir(val: float):
	DIR = val
	face_anim(val)

func face_anim(val: float): ANIM.global_rotation = val

func spin_anim(val: float = DIR):

	if abs(val - ANIM.global_rotation) > PI: val += 2 * PI

	var tween = ANIM.create_tween()
	tween.tween_property(ANIM, 'global_rotation', val, 0.25)


# Movement Controls ----------------------------------------------------------------------------- #

func move(pos: Vector2):

	var tween = create_tween()
	tween.tween_property(self, 'position', pos, 0.25)

	await tween.finished
	self._reset()	# for Own.gd in Play mode

	SIGNALS.emit_signal('done_moving')


# Death Animations ------------------------------------------------------------------------------ #

enum KILLS { BURST, SLICE, PIXEL }

func die():

	var anim = randi() % KILLS.size()
	KILL.play('%02d' % anim)
	
	await get_tree().create_timer(1.0).timeout
	FILTERS.hide()
	ANIM.hide()

	await KILL.animation_finished
	queue_free()

	SIGNALS.emit_signal('done_killing')
