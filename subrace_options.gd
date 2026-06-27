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


# Core logic to rebuild, select defaults, or lock down the dropdown
func _update_subrace_dropdown(race_id: String) -> void:
	clear()
	
	var subraces: Array[String] = _get_subraces_from_txt(race_id)
	
	# Case A: No subraces exist
	if subraces.is_empty():
		add_item(race_id.capitalize())
		disabled = true # Prevents the dropdown from popping open when clicked
		return
		
	# Case B: Subraces exist! Enable interaction
	disabled = false
	
	for sub_id in subraces:
		# Clean up underscores for human-readable UI text (e.g., "stone_dwarf" -> "Stone Dwarf")
		var clean_name = sub_id.replace("_", " ").capitalize()
		add_item(clean_name)
		
		# Save the raw ID inside the item's metadata for your gameplay logic later
		set_item_metadata(get_item_count() - 1, sub_id)
	
	# Auto-select defaults where applicable
	if DEFAULT_SUBRACES.has(race_id):
		var target_default = DEFAULT_SUBRACES[race_id]
		for i in range(get_item_count()):
			if get_item_metadata(i) == target_default:
				select(i)
				break
	else:
		# Fallback to the first subrace if no explicit default mapping is set
		select(0)


# Tab-Delimited Parser for Subraces
func _get_subraces_from_txt(target_id: String) -> Array[String]:
	var found_subraces: Array[String] = []
	
	if not FileAccess.file_exists(TXT_PATH):
		return found_subraces
		
	var file = FileAccess.open(TXT_PATH, FileAccess.READ)
	
	# Header tracking
	var raw_headers = file.get_csv_line("\t")
	var headers: Array[String] = []
	for header in raw_headers:
		headers.append(header.strip_edges().to_lower())
		
	var id_col = headers.find("race_id")
	var subrace_col = headers.find("subraces")
	
	if id_col == -1 or subrace_col == -1:
		file.close()
		return found_subraces
		
	# Scan rows
	while not file.eof_reached():
		var row = file.get_csv_line("\t")
		
		if row.size() > id_col and row[id_col].strip_edges() == target_id:
			if row.size() > subrace_col:
				# Clear out the triple-quotes from the CSV parser
				var raw_string = row[subrace_col].strip_edges().replace('"', '')
				
				if not raw_string.is_empty():
					for subrace in raw_string.split(","):
						var clean_subrace = subrace.strip_edges()
						if not clean_subrace.is_empty():
							found_subraces.append(clean_subrace)
			break
			
	file.close()
	return found_subraces
