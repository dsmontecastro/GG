extends Unit
class_name Ally


# Constants
const UNITS = 'Units'
const ALLIES = 'Allies'

# Member Scenes
@onready var Moves = $Moves


# Core Functions ------------------------------------------------------------- #

func _ready():
	add_to_group(ALLIES, true)
	add_to_group(UNITS, true)
	disconnect("mouse_exited", Callable(self, "mouse_out"))
	connect("input_event", Callable(self, "move_unit"))
	connect("mouse_exited", Callable(self, "unfocus"))
	set_dir(ANIM.global_rotation)
	set_process(false)

func _reset():
	connect("input_event", Callable(self, "move_unit"))
	connect("mouse_exited", Callable(self, "unfocus"))
	toggle_foes(true)
	spin_anim(DIR)
	ANIM.stop()


# Basic Functions ------------------------------------------------------------------------------- #

func unfocus():
	toggle_moves(false)
	spin_anim(DIR)

func toggle_foes(val: bool):
	get_tree().call_group("Enemies", "toggle", val)

func toggle_moves(val: bool):

	set_process(val)
	toggle_foes(!val)
	if !val: mouse_out()

	Moves.visible = val
	Moves.collision_use_parent = val



# Movement Functions --------------------------------------------------------------------------- #

func move_unit(_v, _e, _i):
	if USER.IS_TURN and Input.is_action_just_pressed("Click"):
		if is_processing():
			send_move(get_global_mouse_position())
		else: toggle_moves(true)


func send_move(_to: Vector2): pass

	#var from = Grid.local_to_map(position)
#
	#to = Moves.to_local(to)
	#to = Moves.local_to_map(to)
#
	#if to != Vector2.ZERO:
		#if Board.is_valid_to(from + to):
			#disconnect("input_event", Callable(self, "to_unit"))
			#disconnect("mouse_exited", Callable(self, "unfocus"))
			#SIGNALS.emit_signal("move", from, to)
			#toggle_moves(false)


# Orient towards Mouse -------------------------------------------------------------------------- #

func _process(_delta):
	var mouse = get_global_mouse_position()
	ANIM.look_at(mouse)
	ANIM.rotate(-PI/2)
