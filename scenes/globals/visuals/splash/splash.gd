extends AnimatedSprite2D

const TOTAL = 1
const DELAY = 0.5

@onready var Anims = $Anims
@onready var Delay = $Delay

func _ready():

	for i in range(TOTAL):
		Anims.play(str(i))
		await Anims.animation_finished
		Delay.start(DELAY)
		await Delay.timeout

	LOADER.change_scene_to_file(LOADER.SCENE.MENU)
