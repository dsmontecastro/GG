extends Node
## Represents the current lobby or the [ROOM] the user belongs to.


var ID := 0						## Tracker for the current lobby's ID.
var NAME := ''					## Tracker for the current lobby's name.
var MEMBERS: Dictionary = {}	## Tracker for the current lobby's members.


# Core Functions ------------------------------------------------------------- #

func _reset():
	ID = 0
	NAME = ''
	MEMBERS.clear()


## Leaves the current [ROOM].
func _leave():

	if ID > 0:

		Steam.leaveLobby(ID)
		for memberID in ROOM.MEMBERS:
			if memberID != USER.ID:
				Steam.closeP2PSessionWithUser(ID)

		P2P._reset()
		_reset()
		
		print('User has left Lobby#%s' % ID)
	
	else: print('User was not in a lobby...')


# Members Handling ----------------------------------------------------------- #

## Adds [class ROOM.Memeber] with the given parameters.
func add(id: int, user: String, form: String):
	if id > 0 and user: MEMBERS[id] = Member.new(user, form)


## Clears the [member ROOM.MEMBERS] dictionary.
func clear(): MEMBERS.clear()


## Returns the number of users currently with the user.
func count() -> int: return MEMBERS.size()


## Template for handling [b]members[/b] in a lobby.
class Member:

	var user: String
	var form: String

	func _init(userName: String, userForm: String):
		user = userName
		form = userForm
