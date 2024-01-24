extends Node2D
class_name Board
## Core [Board] class, used control its children [Base] and [Field] components.
## This section contains the common class members and methods.


## User's [Base]
@onready var OWN: Base = $White if USER.HOSTING else $Black

## Foe's [Base]
@onready var FOE: Base = $Black if USER.HOSTING else $White
