extends CanvasLayer
## Responsible for loading in and transitioning between scenes.


# Memeber Scenes
@onready var ANIM: LoaderAnim = $Anim


## Dictionary keys for [member LOADER.SCENES].
enum SCENE_NAMES { MENU, GAME }


## Dictionary of [class LOADER.SceneResource]s.
var SCENES: Dictionary = {
	MENU = SceneResource.new('res://scenes/menu/menu.tscn'),
	GAME = SceneResource.new('res://scenes/game/game.tscn'),
}


## The [class LOADER.SceneResource] to be switched to, if ever.
var TARGET_SCENE: SceneResource = null


# Core Functions ------------------------------------------------------------- #

func _ready():
	
	SIGNALS.loader_covered.connect(load_in)
	SCENES.MENU.load_forced()

	for resource in SCENES:
		var scene: SceneResource = SCENES[resource]
		if !scene.loaded: scene.load_in()
	set_process(true)


func _process(_d):
	var completed := check_progress()
	if completed:
		print('Scenes have loaded!')
		set_process(false)


# Resource Loading ----------------------------------------------------------- #

## Translate an item from [enum LOADER.SCENE_NAMES] to its key as a [String].
func get_scene_name(target: SCENE_NAMES) -> String:
	return SCENE_NAMES.keys()[target]


## Prepates to load in a valid [memeber LOADER.TARGET_SCENE]
## from [member LOADER.SCENES].[br]
## Also alerts [LoaderAnim] to [method LoaderAnim.transition] in.
func load_to(target: SCENE_NAMES):
	
	var resource: String = get_scene_name(target)
	var scene: SceneResource = SCENES[resource]

	if scene.loaded:
		print('Loading to %s' % resource)
		SIGNALS.loading_scene.emit(true)
		TARGET_SCENE = scene

	else: print('[%s] Scene is not yet loaded.' % resource)


## Loads the [member LOADER.TARGET_SCENE] after [signal SIGNALS.loading_covered]
## has been emitted, obscuring the viewport.[br]
## A null or invalid scene will be ignored.[br]
## Lastly, alerts [LoaderAnim] to [method LoaderAnim.transition] out.
func load_in():
	if TARGET_SCENE:
		get_tree().call_deferred('change_scene_to_packed', TARGET_SCENE.resource)
		TARGET_SCENE = null
	SIGNALS.loading_scene.emit(false)


## Checks to see if all [class LOADER.SceneResources] in [member LOADER.SCENES]
## have finished loading.
func check_progress() -> bool:

	for resource in SCENES:
		var scene: SceneResource = SCENES[resource]
		if !scene.loaded:
			var success := scene.load_status()
			if not success: return false

	return true


# Scene Resource class ------------------------------------------------------- #

## Template for handling storing [b]scenes[/b] in [LOADER].
class SceneResource:

	var path: String			## Path to resource to be loaded
	var resource: Resource		## Actual [Resource] object
	var loaded := false			## Indicator for a "finished" loading state


	## Sets the proper [member LOADER.SceneResource.path].[br]
	## If invalid, this object will display an [Error] and delete itself.
	func _init(file_path: String):
		if FileAccess.file_exists(file_path): path = file_path
		else:
			_err('No such file exists...')
			free()


	## Display an [Error] page along with the appropriate message.
	func _err(msg: String): SIGNALS.error.emit(msg)


	##  Performs a threaded load on the [member LOADER.SceneResource.path].
	func load_in(): ResourceLoader.load_threaded_request(path)


	##  Performs a non-threaded load on the [member LOADER.SceneResource.path].
	func load_forced():
		resource = ResourceLoader.load(path)
		loaded = true


	## Checks for and updates the [member LOADER.SceneResource.loaded] status
	## based on the [method ResourceLoader.load_threaded_get_status] results.
	func load_status() -> bool:

		var progress := []
		var success := false
		var status := ResourceLoader.load_threaded_get_status(path, progress)

		match status:

			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				var msg := 'Unable to load the resource from "%s".' % path
				_err(msg)

			ResourceLoader.THREAD_LOAD_FAILED:
				var msg := 'Issue occured while loading files from "%s".' % path
				_err(msg)

			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				#print('Working "%s": %s' % [path, progress])
				pass

			ResourceLoader.THREAD_LOAD_LOADED:
				resource = ResourceLoader.load_threaded_get(path)
				success = true
				loaded = true

		return success
