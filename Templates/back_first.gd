extends Button

@export var target_scene := "res://opening_page.tscn"
@export var pressed_scale := Vector2(0.95, 0.95)

var tween: Tween
var base_scale: Vector2

func _ready():
	# store the real base scale (ex: 1, 0.8)
	base_scale = scale
	pressed.connect(_on_pressed)

	# scale feedback
	button_down.connect(func(): scale = pressed_scale)
	button_up.connect(func(): scale = base_scale)
	mouse_exited.connect(func(): scale = base_scale)

func _on_pressed():
	get_tree().change_scene_to_file(target_scene)
