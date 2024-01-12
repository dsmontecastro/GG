extends MarginContainer

var id = -1
const LIM = 15
const TAG = LOBBY.TAG


func set_id(val: int): id = val

func set_host(val: String): $Host.text = trim(val) + "    "

func set_lobby(val: String):
	if val: val = val.replace(TAG, "")
	$Lobby.text = "  " + trim(val)


func trim(val: String) -> String:
	if len(val) > LIM:
		val = val.substr(0, LIM-3) + "..."
	return val


func _on_pressed(): LOBBY.join_lobby(id)
