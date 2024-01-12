extends Node

const FORMAT = Image.FORMAT_RGBA8

@onready var Name = $Name
@onready var Anim = $Anim
@onready var Icon = $Icon


func set_name(val: String): Name.text = val


func set_anim(val: bool):

	if not val: Anim.play("Toggle", true)

	else:
		Anim.play("Toggle")
		await Anim.animation_finished
		Anim.play("Loader")


func set_icon(size: int, buffer: PackedByteArray):

	var img = Image.new()
	var tex = ImageTexture.new()

	img.create_from_data(size, size, false, FORMAT, buffer)
	tex.create_from_image(img)

	Icon.set_texture(tex)


