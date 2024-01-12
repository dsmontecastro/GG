extends Area2D

@onready var Tiles = $Tiles

func _ready():

	var units = Tiles.get_children()

	if not USER.HOSTING:
		for unit in units:
			unit.swap_color()
