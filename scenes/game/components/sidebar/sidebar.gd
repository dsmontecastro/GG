extends MarginContainer

@onready var BLACK: Profile = $%Black
@onready var WHITE: Profile = $%White

func _ready():

	BLACK.change_team()
	
	if USER.HOSTING: BLACK.toggle_buttons()
	else: WHITE.toggle_buttons()
