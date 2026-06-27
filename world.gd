extends Button

@export var hover_scale := Vector2(1.2, 1.2)
@export var press_scale := Vector2(1.1, 1.1) # Added for configurable shrinkage
@export var anim_time := 0.15
@export var target_scene: PackedScene

var tween: Tween

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_button_pressed)
	button_down.connect(_on_button_down)   # Connected for press visual
	button_up.connect(_on_button_up)       # Connected to restore hover state

func _on_mouse_entered():
	_animate_scale(hover_scale)

func _on_mouse_exited():
	_animate_scale(Vector2.ONE)

func _on_button_down():
	_animate_scale(press_scale)

func _on_button_up():
	if is_hovered():
		_animate_scale(hover_scale)
	else:
		_animate_scale(Vector2.ONE)

func _on_button_pressed():
	if target_scene:
		get_tree().change_scene_to_packed(target_scene)

func _animate_scale(target_scale: Vector2):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", target_scale, anim_time)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
