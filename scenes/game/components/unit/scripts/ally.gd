extends Moveable
class_name Ally
## 


# Member Scenes
@onready var Moves = $Moves


# Core Functions ------------------------------------------------------------- #

func _ready():
	add_to_group(GROUPS.ALLY, true)
	self.input_event.connect(move_unit)
	set_orientation(ANIM.global_rotation)
	set_process(false)

func _reset():
	toggle_foes(true)
	spin_to()
	ANIM.stop()


# Initialization ------------------------------------------------------------- #

## Copies the given [param unit]'s properties to this [Unit].
func copy(unit: Unit):
	name = unit.name
	set_type(unit.TYPE)
	set_team(unit.TEAM)


# Basic Functions ------------------------------------------------------------------------------- #

func mouse_out():
	super.mouse_out()
	toggle_moves(false)
	spin_to()

func toggle_foes(val: bool):
	get_tree().call_group(GROUPS.ENEMY, 'toggle', val)

func toggle_moves(val: bool):

	set_process(val)
	toggle_foes(!val)
	if !val: mouse_out()

	Moves.visible = val
	Moves.collision_use_parent = val



# Movement Functions --------------------------------------------------------------------------- #

func move_unit(_v, _e, _i):
	if USER.IS_TURN and Input.is_action_just_pressed(CLICK):
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
			#disconnect('input_event', Callable(self, 'to_unit'))
			#disconnect('mouse_exited', Callable(self, 'unfocus'))
			#SIGNALS.emit_signal('move', from, to)
			#toggle_moves(false)


# Orient towards Mouse -------------------------------------------------------------------------- #

func _process(_delta):
	var mouse = get_global_mouse_position()
	ANIM.look_at(mouse)
	ANIM.rotate(-PI/2)
