extends Button

@export var hover_scale := Vector2(1.2, 1.2)
@export var anim_time := 0.15

var tween: Tween

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	_animate_scale(hover_scale)

func _on_mouse_exited():
	_animate_scale(Vector2.ONE)

func _animate_scale(target_scale: Vector2):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", target_scale, anim_time)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
