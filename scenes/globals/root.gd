extends Node
## 

# Core Functions ------------------------------------------------------------- #

## Global [b]QUIT[/b] command.
func quit():
	LOBBY._leave()
	get_tree().quit()


# Grid Functions ------------------------------------------------------------- #

## Creates an empty array with the given [param rows] and [param cols].[br]
## Each cell will be instantiated with the supplied [param filler].
func make_arr(rows: int, cols: int, filler = null) -> Array[Array]:

	var arr: Array[Array] = []
	for _r in range(rows):
		var row = []
		row.resize(cols)
		row.fill(filler)
		arr.append(row)

	return arr
