extends Unit
class_name Own

@onready var Moves = $Moves


# Basic Functions ------------------------------------------------------------------------------- #

func _ready():
	add_to_group("Units", true)
	add_to_group("Allies", true)
	disconnect("mouse_exited", Callable(self, "mouse_out"))
	connect("input_event", Callable(self, "move_unit"))
	connect("mouse_exited", Callable(self, "unfocus"))
	set_dir(Anim.global_rotation)
	set_process(false)

func _reset():
	connect("input_event", Callable(self, "move_unit"))
	connect("mouse_exited", Callable(self, "unfocus"))
	toggle_foes(true)
	spin_anim(DIR)
	Anim.stop()


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


func send_move(to: Vector2):

	var from = Grid.local_to_map(position)

	to = Moves.to_local(to)
	to = Moves.local_to_map(to)

	if to != Vector2.ZERO:
		if Board.is_valid_to(from + to):
			disconnect("input_event", Callable(self, "to_unit"))
			disconnect("mouse_exited", Callable(self, "unfocus"))
			SIGNALS.emit_signal("move", from, to)
			toggle_moves(false)


# Orient towards Mouse -------------------------------------------------------------------------- #

func _process(_delta):
	var mouse = get_global_mouse_position()
	Anim.look_at(mouse)
	Anim.rotate(-PI/2)
