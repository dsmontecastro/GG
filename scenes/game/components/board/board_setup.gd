extends Board
class_name Board_Setup
## This section contains the setup-related members and methods.

## Ready-function to be called by the core Core-Class.
func setup_ready():
	SIGNALS.connect(SIGNALS.SETUP.FINISH, Callable(self, "setup_finished"))
	OWN.lighten()
	FOE.darken()


func setup_finished():
	$Field.setup_finished()

func game_play():
	toggle_bases()
	$Field.game_play()

func toggle_bases():
	OWN.toggle()
	FOE.toggle()
