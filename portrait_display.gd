extends TextureRect
class_name PortraitDisplay

# Designer-configurable fade durations exposed directly in the Inspector
@export var fade_out_time: float = 0.2
@export var fade_in_time: float = 0.25

const IMGS_DIR: String = "res://GameData/RaceResources/imgs/"

# Prevents a new fade from interrupting one that's already mid-flight
var _is_transitioning: bool = false

## Call this from your main selection script whenever race/subrace/gender changes
func change_character_portrait(race: String, subrace: String, gender: String) -> void:
	var clean_race = race.strip_edges().to_lower()
	var clean_sub = subrace.strip_edges().to_lower()
	var clean_gender = gender.strip_edges().to_lower()

	if clean_gender == "male": clean_gender = "m"
	if clean_gender == "female": clean_gender = "f"

	var file_name: String = ""
	if clean_sub.is_empty() or clean_sub == clean_race:
		file_name = clean_race + "_" + clean_gender + ".png"
	else:
		var sanitized_sub = clean_sub.replace("-", "_").replace(" ", "_")
		file_name = clean_race + "_" + sanitized_sub + "_" + clean_gender + ".png"

	_load_and_display(IMGS_DIR + file_name)


## Debug entry point: takes an already-built key like "human_caeorn_m"
func display_from_key(key: String) -> void:
	_load_and_display(IMGS_DIR + key.strip_edges().to_lower() + ".png")


func _load_and_display(full_path: String) -> void:
	if not ResourceLoader.exists(full_path):
		push_error("Portrait art asset not found at path: " + full_path)
		return
	var new_texture = load(full_path) as Texture2D
	_execute_fade_transition(new_texture)


func _execute_fade_transition(target_texture: Texture2D) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_out_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(func():
		texture = target_texture
	)
	tween.tween_property(self, "modulate:a", 1.0, fade_in_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		_is_transitioning = false
	)
