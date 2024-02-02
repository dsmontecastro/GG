extends Unit
class_name Moveable
## Allows for movement within a [Field], split from the [Draggable] class.[br]
## Contains orientation and movement-based position methods and functions.


# Enumerations
enum STATES { NONE, MOVING, DYING }		## Enums for [member Moveable.STATE].

# Trackers
@onready var CELL := Vector2i.ZERO		## 
@onready var STATE := STATES.NONE		## Tracker for animation state.


# Core Functions ------------------------------------------------------------- #

## Calls the parent [method Unit._ready] and connects new [signal]s.
func _ready():
	super._ready()
	ANIM.animation_finished.connect(end_death)


# Movement Tweening ---------------------------------------------------------- #

## Dedicated setter for [member Moveable.CELL].
func set_cell(cell: Vector2i): CELL = cell


## Slides towards the give [param pos].
func move(pos: Vector2):

	var tween := create_tween()
	tween.tween_property(self, 'position', pos, 0.25)

	await tween.finished
	SIGNALS.has_move.emit()


# Death Animation ------------------------------------------------------------------------------ #

## 
@onready var KILLS: Array = $Death.sprite_frames.animations


## Plays a random [member Unit.DEATH] animation, and hides it from view.
func die():
	randomize()
	var index := randi() % KILLS.size()
	var anim: String = KILLS[index]
	DEATH.play(anim)

	## Wait for [member Unit.KILL] animation to reach 1 second.
	await get_tree().create_timer(1.0).timeout

	FILTER.hide()
	ANIM.hide()


## After [method Moveable.die] is finished, emits a [signal] upwards.
func end_death(): SIGNALS.has_died.emit(self)
