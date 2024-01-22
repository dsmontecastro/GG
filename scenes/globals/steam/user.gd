extends Node
## Represents the user's information. Additionally initializes [Steam].


# User Information
var ID = 0				## Steam User's ID.
var NAME = ''			## Steam User's name.
var OWNED := false		## Check for game ownership.
var ONLINE := false		## Check if user is logged in or not.

# Game Information
var HOSTING := false	## Check if user is hosting a game.
var READIED := false	## Check if user is ready to start a game.
var IN_GAME := false	## Check if user is in a game.
var IS_TURN := false	## Check if user is currently having their turn.


# Core Functions ------------------------------------------------------------- #

## Initialize Steamworks, bsaed on the official templates and tutorials.
## @tutorial: https://godotsteam.com/tutorials/initializing/
func _ready():

	# Get the initialization dictionary from Steam
	var INIT: Dictionary = Steam.steamInit()

	# If the status isn't one, print out the possible error and quit the program
	if INIT['status'] != 1:
		print('[STEAM] Failed to initialize: ' + str(INIT['verbal']) + ' Shutting down...')
		get_tree().quit()

	# Fill in User Information
	ID = Steam.getSteamID()
	NAME = Steam.getPersonaName()
	OWNED = Steam.isSubscribed()
	ONLINE = Steam.loggedOn()

	# Check if account owns the game
	if OWNED == false:
		print('[STEAM] User does not own this game')
		# Uncomment this line to close the game if the user does not own the game
		# get_tree().quit()


## Resets the game-related members to their initial values.
func _reset():
	HOSTING = false
	READIED = false
	IN_GAME = false
	IS_TURN = false
