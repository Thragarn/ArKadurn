extends Button

@export var hover_scale := Vector2(1.1, 1.1)
@export var click_scale := Vector2(0.9, 0.9) # Shrinks to 90% size when clicked
@export var anim_time := 0.1

var tween: Tween

func _ready():
	# Connect hover signals
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Connect click/press signals
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	
	# Force the scaling pivot point to the absolute center of the button
	# This replaces the missing Grow Direction settings so it shrinks inward
	pivot_offset = size / 2.0
	resized.connect(func(): pivot_offset = size / 2.0)

func _on_mouse_entered():
	# Only grow if the player isn't actively holding the click down
	if not is_pressed():
		_animate_scale(hover_scale)

func _on_mouse_exited():
	if not is_pressed():
		_animate_scale(Vector2.ONE)

func _on_button_down():
	# Instantly shrink inward when pressed down
	_animate_scale(click_scale)

func _on_button_up():
	# When released, snap back to hover scale if mouse is still over it, otherwise normal size
	if get_global_rect().has_point(get_global_mouse_position()):
		_animate_scale(hover_scale)
	else:
		_animate_scale(Vector2.ONE)

func _animate_scale(target_scale: Vector2):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", target_scale, anim_time)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
