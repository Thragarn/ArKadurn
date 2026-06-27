extends OptionButton

# Path to your master race data file
const TXT_PATH: String = "res://GameData/RaceResources/racestxt.txt"

# Default subrace mappings (matching the precise spelling in your TXT file)
const DEFAULT_SUBRACES: Dictionary = {
	"human": "caeorn",
	"elf": "high-elf",
	"dwarf": "stone_dwarf",
	"ogre": "white_ogre"
}

# Keep a local flag to easily know if this button should act dead
var _is_locked_button: bool = false

func _ready() -> void:
	# 1. Dynamically find the race buttons stack via its Scene Unique Name
	var buttons_stack = get_node_or_null("%racebuttons")
	
	if buttons_stack:
		# Listen for whenever the main script adds new buttons to the stack
		buttons_stack.child_entered_tree.connect(_on_race_button_spawned)
		
		# Catch any buttons that might somehow be there already
		for child in buttons_stack.get_children():
			_on_race_button_spawned(child)
	
	# 2. Match the main script's startup behavior by checking the very first race
	call_deferred("_initialize_default_selection")


func _initialize_default_selection() -> void:
	# Check if DataManager is ready and has races registered
	if typeof(DataManager) == TYPE_OBJECT and "races" in DataManager:
		var all_race_ids = DataManager.races.keys()
		if not all_race_ids.is_empty():
			_update_subrace_dropdown(all_race_ids[0])


# This auto-runs whenever the main script duplicates a template button into the stack!
func _on_race_button_spawned(node: Node) -> void:
	if node is Button:
		# Sneakily listen to its pressed signal without disrupting the main script
		node.pressed.connect(_on_race_button_pressed.bind(node))


func _on_race_button_pressed(button: Button) -> void:
	var race_id = button.get_meta("race_id")
	_update_subrace_dropdown(race_id)


# Core logic to rebuild or lock down the dropdown
func _update_subrace_dropdown(race_id: String) -> void:
	clear()
	
	var subraces: Array[String] = _get_subraces_from_txt(race_id)
	var popup: PopupMenu = get_popup()
	
	# Case A: No subraces exist (Keeps your direct Inspector Theme adjustments intact)
	if subraces.is_empty():
		add_item(race_id.capitalize())
		
		# Set flag to lock interaction completely, while leaving colors perfectly active
		_is_locked_button = true
		disabled = false 
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		return
		
	# Case B: Subraces exist! Enable full interaction
	_is_locked_button = false
	disabled = false
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	for sub_id in subraces:
		var clean_name = sub_id.replace("_", " ").capitalize()
		add_item(clean_name)
		
		var current_index = get_item_count() - 1
		set_item_metadata(current_index, sub_id)
		
		# Forcefully destroy the radio-checking behavior for this item slot
		popup.set_item_as_checkable(current_index, false)
		popup.set_item_as_radio_checkable(current_index, false)
	
	# Auto-select defaults where applicable
	if DEFAULT_SUBRACES.has(race_id):
		var target_default = DEFAULT_SUBRACES[race_id]
		for i in range(get_item_count()):
			if get_item_metadata(i) == target_default:
				select(i)
				break
	else:
		select(0)


# This intercepts clicks before Godot's OptionButton can trigger the dropdown window.
func _gui_input(event: InputEvent) -> void:
	if _is_locked_button and event is InputEventMouseButton:
		# Swallowing the input event prevents the dropdown menu from appearing entirely
		accept_event()


# Tab-Delimited Parser for Subraces
func _get_subraces_from_txt(target_id: String) -> Array[String]:
	var found_subraces: Array[String] = []
	
	if not FileAccess.file_exists(TXT_PATH):
		return found_subraces
		
	var file = FileAccess.open(TXT_PATH, FileAccess.READ)
	
	var raw_headers = file.get_csv_line("\t")
	var headers: Array[String] = []
	for header in raw_headers:
		headers.append(header.strip_edges().to_lower())
		
	var id_col = headers.find("race_id")
	var subrace_col = headers.find("subraces")
	
	if id_col == -1 or subrace_col == -1:
		file.close()
		return found_subraces
		
	while not file.eof_reached():
		var row = file.get_csv_line("\t")
		
		if row.size() > id_col and row[id_col].strip_edges() == target_id:
			if row.size() > subrace_col:
				var raw_string = row[subrace_col].strip_edges().replace('"', '')
				
				if not raw_string.is_empty():
					for subrace in raw_string.split(","):
						var clean_subrace = subrace.strip_edges()
						if not clean_subrace.is_empty():
							found_subraces.append(clean_subrace)
			break
			
	file.close()
	return found_subraces
