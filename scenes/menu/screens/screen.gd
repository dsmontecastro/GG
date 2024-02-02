extends MarginContainer
class_name Screen
## Abstract Class that comprises the [Menu] components.
## Note: Override the [method Screen._start] and [method Screen._reset] methods.


# Core Functions ------------------------------------------------------------- #

func _start(): pass		## To be overridden.
func _reset(): pass		## To be overridden.


## Emits a signal to the [Menu] that some error has occured,
## along with an accompanying [param message].
func _err(msg: String): SIGNALS.error.emit(msg)


## Emits a signal to the [Menu] that a game has succesfully been prepared.
## Will log [param message] for debugging.
func _play(msg: String): SIGNALS.menu_play.emit(msg)


## Parses the response recieved from a [b]join[/b] or [b]host[/b] request.
## A [param success] will be forwarded to [method Menu._play].[br]
## Else, an [Error] page will be displayed.
func _response(success: bool, msg: String):
	if success: _play(msg)
	else: _err(msg)


# Tweening ------------------------------------------------------------------- #

## Default duration for Tweening
const DURATION = 0.15

## Default offset for Tweening
@onready var OFFSET := Vector2(get_viewport().get_visible_rect().size.x, 0)


## Animation-Tween for sliding a [Control] Node given an [param offset].
func slide(offset: Vector2):
	var pos := get_position()
	var tween := create_tween()
	tween.tween_property(self, 'position', pos + offset, DURATION)


## Shortcut for right-oriented [method Menu.slide].
func slideR(): slide(OFFSET)


## Shortcut for left-oriented [method Menu.slide].
func slideL(): slide(-OFFSET)
