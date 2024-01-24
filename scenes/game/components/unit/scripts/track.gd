extends Area2D

@onready var Anim = $Anim
@onready var Count = $Count

@export var MAX = 1: set = set_max
func set_max(val: int): MAX = val


func _ready():
	connect("input_event", Callable(self, "_click"))
	set_max(MAX)
	recount(0)

func _click(_v, _e, _i):

	var offset = 0
	if Input.is_action_just_pressed("Click"): offset = 1
	elif Input.is_action_just_pressed("Click"): offset = -1

	if offset: recount(offset)


var count = MAX
func recount(val: int):

	count = clamp(count + val, 0, MAX)
	Count.text = "x" + str(count)

	var tween = Anim.create_tween()
	if count == 0:
		tween.tween_property(Anim, "modulate:a", 0.5, 0.25)
	else: tween.tween_property(Anim, "modulate:a", 1.0, 0.25)


const invertModulate = Color(0.25, 0.25, 0.25)
var invertMaterial = load("res://assets/shaders/invert/invert.material")

func swap_color():
	Anim.material = invertMaterial
	Anim.modulate = invertModulate
	Anim.visible = true
