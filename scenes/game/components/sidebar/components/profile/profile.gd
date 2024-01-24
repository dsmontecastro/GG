extends PanelContainer
class_name Profile

@onready var NAME: Label = $%Name
@onready var TEAM: Panel = $%Team
@onready var ICON: TextureRect = $%Icon
@onready var TEXT: VBoxContainer = $%Text
@onready var BUTTONS: HBoxContainer = $%Buttons


func change_team():
	recolor()
	resort()

func resort():
	var child = TEXT.get_child(0)
	TEXT.move_child(child, -1)

func recolor():

	var style: StyleBoxFlat = TEAM.get_theme_stylebox('panel').duplicate()
	style.bg_color = Color.BLACK

	TEAM.add_theme_stylebox_override('panel', style)
	TEAM.remove_theme_stylebox_override('panel')


func toggle_buttons():
	for button in BUTTONS.get_children():
		if button is Button:
			button.disabled = !button.disabled
