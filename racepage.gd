extends Control

# Find your empty vertical stack where the menu list goes
@onready var buttons_stack: VBoxContainer = %racebuttons

# Find your visually designed template button from the scene tree
@onready var template_button: Button = $RaceTemplateButton

func _ready() -> void:
	# FORCE THE CONTAINERS TO STRETCH: 
	# This code tells the VBox and the ScrollContainer to stop being narrow 
	# and force themselves to fill the entire horizontal space assigned to them.
	buttons_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if buttons_stack.get_parent() is ScrollContainer:
		buttons_stack.get_parent().size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	populate_race_menu()

func populate_race_menu() -> void:
	# 1. Clear out any old buttons
	for child in buttons_stack.get_children():
		child.queue_free()
		
	# 2. Grab your list of 13 races from the data database
	var all_race_ids = DataManager.races.keys()
	
	# 3. Duplicate your custom button design for each race
	for r_id in all_race_ids:
		
		# COPY MACHINE: This makes an exact twin of your custom TemplateButton!
		var new_button = template_button.duplicate()
		
		# Make sure this specific twin is visible to the player
		new_button.show()
		
		# Change the text of the twin to match the race name (e.g., "Ogre")
		new_button.text = r_id.capitalize()
		
		# FORCE CENTER TEXT: Completely overrides any left-gluing behavior
		new_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		# FORCE HORIZONTAL EXPANSION: Insists that the button stretches full-width
		new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Tag the button with its raw ID so the game knows what race it belongs to
		new_button.set_meta("race_id", r_id)
		
		# Connect the click event so clicking it does something later
		new_button.pressed.connect(_on_race_button_pressed.bind(new_button))
		
		# Drop the twin right into your scrolling list container
		buttons_stack.add_child(new_button)


# This fires whenever any of your custom-styled twin buttons are clicked!
func _on_race_button_pressed(button: Button) -> void:
	var selected_race_id = button.get_meta("race_id")
	print("Player selected: ", selected_race_id)
	
	display_race_details(selected_race_id)

@warning_ignore("unused_parameter")
func display_race_details(race_id: String) -> void:
	pass
