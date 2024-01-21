extends Popup
class_name Error

## The default [b]error message[/b] to display.
const DEF_MSG = "An unknown error has occurred."

## The [Label] to display the [b]error message[/b].
@onready var Message: LineEdit = $%Message


# Core Functions ------------------------------------------------------------- #

func _ready(): SIGNALS.warning.connect(_start)

## Shows the [Errpr] page, along with the accompanying message.
func _start(msg: String = DEF_MSG):
	print("[WARNING] %s" % msg)
	Message.text = msg
	self.show()

## Resets and hides the [Errpr] page.
func _reset():
	SIGNALS.emit_signal("reset")
	Message.text = ""
	self.hide()
