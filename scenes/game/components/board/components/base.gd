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



const COLORS = {
	DEF = Color(0,0,0,0),
	DARK = Color(0,0,0,0.5),
	LITE = Color(1,1,1,0.5)
}

func reset(): self.modulate = Color(0,0,0,0)
func toggle():
	if self.modulate == COLORS.DARK:
		self.modulate = COLORS.LITE
	else: self.modulate = COLORS.DARK
	print("%s: %s" % [self.name, self.modulate])
	
func darken(): self.modulate = Color(0,0,0,0.5)
func lighten(): self.modulate = Color(1,1,1,0.5)
