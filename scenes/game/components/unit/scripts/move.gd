extends Unit
class_name Moveable
## Allows for movement within a [Field], split from the [Draggable] class.[br]
## Contains orientation and movement-based position methods and functions.


# Enumerations
enum STATES { NONE, MOVING, DYING }		## Enums for [member Moveable.STATE].

# Trackers
@onready var CELL := Vector2i.ZERO		## 
@onready var STATE := STATES.NONE		## Tracker for animation state.

# Tween
@onready var TWEEN := create_tween()	## Handler for [method Moveable.move]


# Core Functions ------------------------------------------------------------- #

## 
func _ready():
	super._ready()
	ANIM.animation_finished.connect(end_death)
	TWEEN.finished.connect(end_move)


# Movement Tween ------------------------------------------------------------- #

## Dedicated setter for [member Moveable.CELL].
func set_cell(cell: Vector2i): CELL = cell


## 
func move(pos: Vector2):
	TWEEN.tween_property(self, 'position', pos, 0.25)


## 
func end_move(): SIGNALS.has_move.emit()


# Death Animation ------------------------------------------------------------------------------ #

## 
@onready var KILLS = KILL.sprite_frames.animations


## 
func die():
	randomize()
	var index := randi() % KILLs.size()
	var anim := KILLS[index]
	KILL.play(anim)

	while ANIM.frame <= 30: pass

	FILTERS.hide()
	ANIM.hide()

## 
func end_death():
	queue_free()
	SIGNALS.has_died.emit()
