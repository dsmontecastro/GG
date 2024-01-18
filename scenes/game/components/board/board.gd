extends Node2D
class_name Board

@onready var FIELD: Field = $Field
@onready var BLACK: Base = $Black
@onready var WHITE: Base = $White
@onready var OWN: Base = WHITE
@onready var FOE: Base = BLACK


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	SIGNALS.connect(SIGNALS.SETUP.FINISH, Callable(self, "setup_finished"))
	if USER.HOSTING:
		OWN = BLACK
		FOE = WHITE
	OWN.lighten()
	FOE.darken()


# In-game Functions ----------------------------------------------------------------------------- #

func setup_reset():

func setup_finished():
	FIELD.setup_finished()

func game_play():
	toggle_bases()
	# Move all Children in either Bases to Field
	FIELD.game_play()


# Landing Area Functions for Drag-&-Drop -------------------------------------------------------- #

func toggle_bases():
	OWN.toggle()
	FOE.toggle()
