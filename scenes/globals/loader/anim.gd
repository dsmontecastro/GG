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
	self.animation_finished.connect(anim_finished)
	SIGNALS.loading_scene.connect(is_loading)


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


## Controller for [member LoaderAnim.LOADING], triggered by
## [signal SIGNALS.loading_scene] when [LOADER] is attempting to change scene.
func is_loading(val: bool):
	LOADING = val
	transition()


## Triggered when the current animation has stopped playing.[br]
## Emits [signal SIGNALS.loading_covered] & [method LoaderAnim.transition]s out
## if the animation is currently "transitioning in".[br]
## Otherwise, [method AnimatedSprite2D.stop]s the animations.
func anim_finished():
	if frame == 0: stop()
	else:
		SIGNALS.loader_covered.emit()
		transition()


## If no animation is currently playing, plays the appropriate animation [br]
## based on the [member LoaderAnim.LOADING] state.
func transition():
	if not is_playing():
		if LOADING: _start()
		else: _reset()
