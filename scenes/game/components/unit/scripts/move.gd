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

## 
func _ready():
	super._ready()
	ANIM.animation_finished.connect(end_death)


# Movement Tween ------------------------------------------------------------- #

## Dedicated setter for [member Moveable.CELL].
func set_cell(cell: Vector2i): CELL = cell


## 
func move(pos: Vector2):

	var tween := create_tween()
	tween.tween_property(self, 'position', pos, 0.25)

	await tween.finished
	SIGNALS.has_move.emit()


# Death Animation ------------------------------------------------------------------------------ #

## 
@onready var KILLS: Array = $Kill.sprite_frames.animations


## 
func die():
	randomize()
	var index := randi() % KILLS.size()
	var anim: String = KILLS[index]
	KILL.play(anim)

	## Wait for [member Unit.KILL] animation to reach 1 second.
	await get_tree().create_timer(1.0).timeout

	FILTERS.hide()
	ANIM.hide()

## 
func end_death():
	queue_free()
	SIGNALS.has_died.emit()
