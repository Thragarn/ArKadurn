extends Control

@onready var fade_rect := $faderect

func _ready():
	fade_rect.modulate.a = 1.0  # start fully black

	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 1.6)
