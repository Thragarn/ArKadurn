extends TextureRect

# Designer-configurable fade durations exposed directly in the Inspector
@export var fade_out_time: float = 0.2
@export var fade_in_time: float = 0.25

const IMGS_DIR: String = "res://GameData/RaceResources/imgs/"

# Internal active tween tracker to prevent animation overlapping/glitching
var _active_tween: Tween

## Call this function from your main selection script whenever a choice changes
func change_character_portrait(race: String, subrace: String, gender: String) -> void:
	# Clean inputs to lowercase to match standard filename practices
	var clean_race = race.strip_edges().to_lower()
	var clean_sub = subrace.strip_edges().to_lower()
	var clean_gender = gender.strip_edges().to_lower()
	
	# Fallback conversion for shortened formatting strings
	if clean_gender == "male": clean_gender = "m"
	if clean_gender == "female": clean_gender = "f"
	
	# Build path dynamically based on your text database structure
	var file_name: String = ""
	
	# Handle cases like Gremlin or Goblin which have NO subraces
	if clean_sub.is_empty() or clean_sub == clean_race:
		file_name = clean_race + "_" + clean_gender + ".png"
	else:
		# Replace dashes or spacing variations to fit the image naming convention
		var sanitized_sub = clean_sub.replace("-", "_").replace(" ", "_")
		file_name = clean_race + "_" + sanitized_sub + "_" + clean_gender + ".png"
		
	var full_path = IMGS_DIR + file_name
	
	# Verify file exists on disk to prevent hard engine crashes
	if not ResourceLoader.exists(full_path):
		push_error("Portrait art asset not found at path: " + full_path)
		return
		
	var new_texture = load(full_path) as Texture2D
	_execute_fade_transition(new_texture)


func _execute_fade_transition(target_texture: Texture2D) -> void:
	# Kill any animation currently running mid-way to prevent stutter cycles
	if _active_tween and _active_tween.is_running():
		_active_tween.kill()
		
	_active_tween = create_tween()
	
	# Phase 1: Smoothly fade down to fully transparent
	_active_tween.tween_property(self, "modulate:a", 0.0, fade_out_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	# Phase 2: Swap the texture asset invisibly while transparent
	_active_tween.tween_callback(func(): texture = target_texture)
	
	# Phase 3: Smoothly fade back up to full visibility
	_active_tween.tween_property(self, "modulate:a", 1.0, fade_in_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
