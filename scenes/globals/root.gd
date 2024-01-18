extends Node

func quit():
	LOBBY.leave()
	get_tree().quit()


# Grid Functions ------------------------------------------------------------ #

func make_arr(rows: int, cols: int, filler = null) -> Array:

	var arr = []
	for _r in range(rows):
		var row = []
		row.resize(cols)
		if filler != null:
			row.fill(filler)
		arr.append(row)

	return arr
