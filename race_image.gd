extends CanvasGroup

@onready var male_button: TextureButton = $male_button
@onready var female_button: TextureButton = $female_button

# Configure your transition time directly in the Inspector (in seconds)
@export var fade_duration: float = 0.5

func _ready() -> void:
	male_button.toggled.connect(_on_gender_button_toggled)
	female_button.toggled.connect(_on_gender_button_toggled)
	
	_update_button_visuals_instant()

func _on_gender_button_toggled(_button_pressed: bool) -> void:
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Fades male_button to 100% opacity if pressed, or 0% opacity if untoggled
	var male_target_alpha = 1.0 if male_button.is_pressed() else 0.0
	tween.tween_property(male_button, "self_modulate:a", male_target_alpha, fade_duration)
	
	# Fades female_button to 100% opacity if pressed, or 0% opacity if untoggled
	var female_target_alpha = 1.0 if female_button.is_pressed() else 0.0
	tween.tween_property(female_button, "self_modulate:a", female_target_alpha, fade_duration)

func _update_button_visuals_instant() -> void:
	male_button.self_modulate.a = 1.0 if male_button.is_pressed() else 0.0
	female_button.self_modulate.a = 1.0 if female_button.is_pressed() else 0.0
