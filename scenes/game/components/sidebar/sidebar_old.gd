extends TileMap

var Own: Node2D
var Foe: Node2D
@onready var Top = $Profiles/Top
@onready var Bot = $Profiles/Bot


# Common Functions ------------------------------------------------------------------------------ #

func _ready():
	Steam.connect("avatar_loaded", Callable(self, "set_profile"))
	update_profiles()

func game_play(): swap_turn(USER.IS_TURN)

func swap_turn(val: bool):
	Own.set_anim(val)
	Foe.set_anim(!val)


# Custom Functions ------------------------------------------------------------------------------ #

func update_profiles():

	print("Updating profiles...")

	if USER.HOSTING:
		Own = Top
		Foe = Bot

	else:
		Own = Bot
		Foe = Top


	if LOBBY.MEMBERS.size() > 0:

		Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, USER.ID)

		if P2P.ENEMY > 0:
			Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, P2P.ENEMY)


func set_profile(id: int, size: int, buffer: PackedByteArray):

	var Profile: Node2D
	if id == P2P.ENEMY: Profile = Foe
	elif id == USER.ID: Profile = Own
	else: Profile = Top

	Profile.set_name(LOBBY.MEMBERS[id]["name"])
	Profile.set_icon(size, buffer)
