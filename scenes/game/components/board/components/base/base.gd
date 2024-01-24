extends TileMap
class_name Base


func _ready():
	setup_ready()


func setup_ready():
	for child: Unit in get_children():
		var coords = local_to_map(child.position)
		toggle_cell(coords)

func toggle_cell(coords: Vector2i):
	var data: TileData = get_cell_tile_data(0, coords)
	if data:
		var filled: bool = data.get_custom_data('filled')
		data.set_custom_data('filled', !filled)



enum LAYERS { BASE, BOARD }
const COLORS = {
	DEF = Color(0,0,0,0),
	DARK = Color(0,0,0,0.5),
	LITE = Color(1,1,1,0.5)
}

func reset(): set_layer_modulate(LAYERS.BOARD, COLORS.DEF)
func darken(): set_layer_modulate(LAYERS.BOARD, COLORS.DARK)
func lighten(): set_layer_modulate(LAYERS.BOARD, COLORS.LITE)

func toggle():

	var color = COLORS.DEF
	var curr = get_layer_modulate(LAYERS.BOARD)

	if curr == COLORS.DARK: color = COLORS.LITE
	elif curr == COLORS.LITE: color = COLORS.DARK
	
	set_layer_modulate(LAYERS.BOARD, color)
	print("%s: %s" % [self.name, self.modulate])
	
