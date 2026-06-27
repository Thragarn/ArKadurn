extends Control

# --- NEW INSPECTOR PARAMETER ---
# This will show up in your Godot Inspector as a color picker!
@export var bold_word_color: Color = Color.YELLOW

# Find your empty vertical stack where the menu list goes
@onready var buttons_stack: VBoxContainer = %racebuttons

# Find your visually designed template button from the scene tree
@onready var template_button: Button = $RaceTemplateButton

# Node paths adjusted for your new hierarchy
@onready var race_title: Label = $Affichage/RaceTitle
@onready var description_label: RichTextLabel = $Affichage/StatScroller/Description

func _ready() -> void:
	# FORCE THE CONTAINERS TO STRETCH: 
	buttons_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if buttons_stack.get_parent() is ScrollContainer:
		buttons_stack.get_parent().size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Full-width stretch configurations
	description_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	description_label.custom_minimum_size = Vector2(0, 100) 
	description_label.fit_content = true 
	description_label.bbcode_enabled = true 
	
	populate_race_menu()
	
	# Forces the menu to display the first registered race by default on startup
	var all_race_ids = DataManager.races.keys()
	if not all_race_ids.is_empty():
		display_race_details(all_race_ids[0])

func populate_race_menu() -> void:
	# 1. Clear out any old buttons
	for child in buttons_stack.get_children():
		child.queue_free()
		
	# 2. Grab your list of 13 races from the data database
	var all_race_ids = DataManager.races.keys()
	
	# 3. Duplicate your custom button design for each race
	for r_id in all_race_ids:
		var new_button = template_button.duplicate()
		new_button.show()
		new_button.text = r_id.capitalize()
		new_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_button.set_meta("race_id", r_id)
		new_button.pressed.connect(_on_race_button_pressed.bind(new_button))
		buttons_stack.add_child(new_button)


# This fires whenever any of your custom-styled twin buttons are clicked!
func _on_race_button_pressed(button: Button) -> void:
	var selected_race_id = button.get_meta("race_id")
	display_race_details(selected_race_id)


func display_race_details(race_id: String) -> void:
	# 1. Fetch the REAL plural name from your tab-delimited file
	var plural_title = _get_plural_from_txt(race_id)
	race_title.text = plural_title
	
	# 2. Construct the path to your txt file
	var file_path = "res://GameData/RaceResources/txts/" + race_id + ".txt"
	
	# 3. Safety Check: If the file exists, read it.
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var description_text = file.get_as_text()
		file.close()
		
		# --- MODIFIED SECTION ---
		# Convert your chosen inspector color into a clean raw hex string (e.g., "ff00ff")
		var hex_code = bold_word_color.to_html(false)
		
		# Wrap your bold strings inside a nested BBCode color block automatically
		var formatted_text = description_text.replace("[b]", "[b][color=#" + hex_code + "]")
		formatted_text = formatted_text.replace("[/b]", "[/color][/b]")
		
		description_label.text = formatted_text
		# ------------------------
	else:
		description_label.text = "[color=red]Missing description file for: " + race_id + "[/color]"


# Tab-Delimited Reader (\t)
func _get_plural_from_txt(target_id: String) -> String:
	var txt_path = "res://GameData/RaceResources/racestxt.txt"
	
	if not FileAccess.file_exists(txt_path):
		return target_id.capitalize()
		
	var file = FileAccess.open(txt_path, FileAccess.READ)
	
	# Pass "\t" to get_csv_line to split cells by Tabs instead of Commas
	var raw_headers = file.get_csv_line("\t")
	var headers: Array = []
	for header in raw_headers:
		headers.append(header.strip_edges().to_lower())
	
	var id_col = headers.find("race_id")
	var plural_col = headers.find("plural")
	
	if id_col == -1 or plural_col == -1:
		file.close()
		return target_id.capitalize()
		
	# Loop through rows to find our matching race ID
	while not file.eof_reached():
		var row = file.get_csv_line("\t")
		
		if row.size() > id_col and row[id_col].strip_edges() == target_id:
			var found_plural = row[plural_col].strip_edges().replace('"', '')
			file.close()
			
			if not found_plural.is_empty():
				return found_plural
			break
			
	file.close()
	return target_id.capitalize()
