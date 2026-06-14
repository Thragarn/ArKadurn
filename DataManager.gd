extends Node

# Memory databases
var races: Dictionary = {}
var assets: Dictionary = {}
var handicaps: Dictionary = {}

func _ready() -> void:
	load_json_database("res://GameData/RaceResources/assets.json", assets)
	load_json_database("res://GameData/RaceResources/handicaps.json", handicaps)
	load_race_csv("res://GameData/RaceResources/racescsv.csv")

# 1. Standard JSON file loader
func load_json_database(file_path: String, target_dict: Dictionary) -> void:
	if not FileAccess.file_exists(file_path):
		printerr("Database file not found: ", file_path)
		return
		
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data = json.get_data()
		for key in data.keys():
			target_dict[key] = data[key]
	else:
		printerr("JSON Parse Error in ", file_path, " line ", json.get_error_line(), ": ", json.get_error_message())

# 2. Advanced CSV Line-by-Line Loader
func load_race_csv(file_path: String) -> void:
	if not FileAccess.file_exists(file_path):
		printerr("CSV file not found: ", file_path)
		return
		
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	# Grab the header row to dynamically map column indices
	var headers = file.get_csv_line(";")
	if headers.size() == 0: return
	
	while not file.eof_reached():
		var row = file.get_csv_line(";")
		if row.size() < headers.size() or row[0].strip_edges() == "": 
			continue # Skip empty or corrupted lines
			
		var race_data = {}
		var current_race_id = row[0].strip_edges()
		
		# Map columns into a dictionary for clean variable access
		for i in range(1, headers.size()):
			var header_title = headers[i].strip_edges()
			var raw_cell_value = row[i].strip_edges()
			
			# Clean up outer string quotes left by spreadsheet exports
			if raw_cell_value.begins_with('"') and raw_cell_value.ends_with('"'):
				raw_cell_value = raw_cell_value.substr(1, raw_cell_value.length() - 2)
			
			# Type conversion: Convert numerical text fields to actual floats/ints
			if raw_cell_value == "" or raw_cell_value == "NaN":
				race_data[header_title] = null
			elif raw_cell_value.is_valid_float():
				race_data[header_title] = raw_cell_value.to_float()
			else:
				race_data[header_title] = raw_cell_value
				
		races[current_race_id] = race_data
	file.close()
	print("Database pipeline fully loaded! Total races registered: ", races.size())
