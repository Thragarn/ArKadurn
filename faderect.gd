extends Control

@onready var fade_rect := $FadeRect

func _ready():
	fade_rect.modulate.a = 1.0  # start fully black

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.65)
