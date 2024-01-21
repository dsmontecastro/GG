extends Screen
class_name MainScreen
## [b]Main [Screen][/b] component, used to navigate to its fellow [Screen]s.


func _ready(): refocus()
func _start(): refocus()
func _reset(): refocus()

## Connects to and quits at the [Root] level.
func quit(): ROOT.quit()


## Autofocus ----------------------------------------------------------------- #

## The [b]Find Button[/b], used as the primary focus.
@onready var FIND: Button = $%Find

## Refocuses
func refocus(): $%Find.grab_focus()
