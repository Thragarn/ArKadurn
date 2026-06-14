extends Button

@export var target_scene := "res://Main Menu.tscn"
@export var fade_delay := 1.6
@export var fade_time := 0.65
@export var pressed_scale := Vector2(0.85, 0.85)

var tween: Tween
var base_scale: Vector2

func _ready():
	# store the real base scale (ex: 1, 0.8)
	base_scale = scale

	# start invisible
	modulate.a = 0.0
	disabled = true

	await get_tree().create_timer(fade_delay).timeout
	disabled = false

	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_time)

	pressed.connect(_on_pressed)

	# scale feedback
	button_down.connect(func(): scale = pressed_scale)
	button_up.connect(func(): scale = base_scale)
	mouse_exited.connect(func(): scale = base_scale)

func _on_pressed():
	get_tree().change_scene_to_file(target_scene)
