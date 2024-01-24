extends CanvasLayer
## 

# Memeber Scenes
@onready var ANIM: LoaderAnim = $Anim


# Scene Management ----------------------------------------------------------- #

##
var TARGET_SCENE: SceneResource = null


##
enum SCENE_NAMES { MENU, GAME }

## 
var SCENES: Dictionary = {
	MENU = SceneResource.new('res://scenes/menu/menu.tscn'),
	GAME = SceneResource.new('res://scenes/game/game.tscn'),
}


# Core Functions ------------------------------------------------------------- #

func _ready():
	
	SIGNALS.loading_covered.connect(load_in)
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

## 
func get_scene_name(target: SCENE_NAMES) -> String:
	return SCENE_NAMES.keys()[target]


## 
func load_to(target: SCENE_NAMES):
	
	var resource: String = get_scene_name(target)
	var scene: SceneResource = SCENES[resource]

	if scene.loaded:
		print('Loading to %s' % resource)
		SIGNALS.loading_scene.emit(true)
		TARGET_SCENE = scene

	else: print('[%s] Scene is not yet loaded.' % resource)


##
func load_in():
	if TARGET_SCENE:
		get_tree().call_deferred('change_scene_to_packed', TARGET_SCENE.resource)
		SIGNALS.loading_scene.emit(false)
		TARGET_SCENE = null


## 
func check_progress() -> bool:

	for resource in SCENES:
		var scene: SceneResource = SCENES[resource]
		if !scene.loaded:
			var success := scene.load_status()
			if not success: return false

	return true


# Scene Resource class ------------------------------------------------------- #

## 
class SceneResource:

	var path: String
	var resource: Resource
	var loaded := false


	## 
	func _init(file_path: String): path = file_path


	## Display an [Error] page along with the appropriate message.
	func _err(msg: String): SIGNALS.error.emit(msg)


	## 
	func load_in(): ResourceLoader.load_threaded_request(path)


	## 
	func load_forced():
		resource = ResourceLoader.load(path)
		loaded = true


	## 
	func load_status() -> bool:

		var progress := []
		var success := false
		var status := ResourceLoader.load_threaded_get_status(path, progress)

		match status:

			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				var msg := 'Unable to load the resource from "%s".' % path
				print(msg)
				_err(msg)

			ResourceLoader.THREAD_LOAD_FAILED:
				var msg := 'Issue occured while loading files from "%s".' % path
				print(msg)
				_err(msg)

			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				#print('Working "%s": %s' % [path, progress])
				pass

			ResourceLoader.THREAD_LOAD_LOADED:
				resource = ResourceLoader.load_threaded_get(path)
				success = true
				loaded = true

		return success
