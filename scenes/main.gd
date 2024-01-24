extends Node
class_name Main
## Entry-Point of the program.
## Essentially the placeholder until a "proper" scene is supplied.


## Loads in the [Menu] scene through [LOADER].
func _ready(): LOADER.load_to(LOADER.SCENE_NAMES.MENU)
