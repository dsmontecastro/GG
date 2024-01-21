extends Screen
class_name OptsScreen
## [b]Options [Screen][/b] component, used to modify global settings.
## [NOTE]: The [Settings] configuration is still uninmplemented. 


## Core Functions ------------------------------------------------------------ #

func _ready(): pass
func _start(): pass
func _reset(): pass

# Disable [LOBBY] and [Game]-related functions for this screen.
func _err(msg: String): pass						## Disabled.
func _play(msg: String): pass						## Disabled.
func _success(success: bool, msg: String): pass		## Disabled.


## Settings Configuration ---------------------------------------------------- #

func save(): pass
func apply(): save()
