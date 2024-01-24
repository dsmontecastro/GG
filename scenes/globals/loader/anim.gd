extends AnimatedSprite2D
class_name LoaderAnim
## Animation-Handler for the [LOADER] singleton.


# Trackers
var LOADING := false

# Member Scenes
@onready var ANIMS: SpriteFrames = sprite_frames
@onready var TRANSITIONS := ANIMS.get_animation_names()
@onready var TRANS_COUNT := TRANSITIONS.size()


# Core Functions ------------------------------------------------------------- #

func _ready():
	#self.animation_finished.connect(transition)
	self.animation_finished.connect(anim_finished)
	SIGNALS.loading_scene.connect(load_finished)


## Swaps to and plays a random [member AnimatedSprite2D.animation]
## from [member LoaderAnim.TRANSITIONS].
func _start():
	swap()
	play()


## Plays the current [member AnimatedSprite2D.animation] backwards.
func _reset(): play_backwards()


# Animation Functions -------------------------------------------------------- #

## Switches to a random [member LoaderAnim.TRANSITION] from its [SpriteFrames].
func swap():
	randomize()
	var id := randi() % TRANS_COUNT
	animation = TRANSITIONS[id]


## Emits the appropriate signal after an animation has finished playing.
func load_finished(val: bool):
	LOADING = val
	transition()


## 
func anim_finished():
	if frame == 0:
		hide()
		stop()
	else:
		SIGNALS.loading_covered.emit()
		transition()


## 
func transition():
	if not is_playing():
		show()
		if LOADING: _start()
		else: _reset()
