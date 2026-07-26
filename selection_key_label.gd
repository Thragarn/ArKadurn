extends Label

# Drag the two nodes below into these Inspector slots after saving this script.
@export var subrace_dropdown: OptionButton      # -> drag "RaceOptions" here
@export var gender_selector: CanvasGroup        # -> drag "race image" here
@export var portrait_display: PortraitDisplay

@onready var race_buttons_stack: VBoxContainer = %racebuttons

var current_race_id: String = ""
var current_subrace_id: String = ""
var current_gender: String = "m"

func _ready() -> void:
	race_buttons_stack.child_entered_tree.connect(_on_race_button_spawned)
	for child in race_buttons_stack.get_children():
		_on_race_button_spawned(child)

	subrace_dropdown.item_selected.connect(_on_subrace_selected)

	gender_selector.get_node("male_button").toggled.connect(_on_gender_toggled)
	gender_selector.get_node("female_button").toggled.connect(_on_gender_toggled)

	call_deferred("_initialize_default_state")

func _initialize_default_state() -> void:
	var all_race_ids = DataManager.races.keys()
	if not all_race_ids.is_empty():
		current_race_id = all_race_ids[0]
	_read_current_subrace()
	_read_current_gender()
	_update_label()

func _on_race_button_spawned(node: Node) -> void:
	if node is Button:
		node.pressed.connect(_on_race_button_pressed.bind(node))

func _on_race_button_pressed(button: Button) -> void:
	current_race_id = button.get_meta("race_id")
	# Wait a beat so RaceOptions finishes rebuilding its dropdown first
	call_deferred("_read_current_subrace")
	call_deferred("_update_label")

func _on_subrace_selected(_index: int) -> void:
	_read_current_subrace()
	_update_label()

func _on_gender_toggled(_pressed: bool) -> void:
	_read_current_gender()
	_update_label()

func _read_current_subrace() -> void:
	var meta = subrace_dropdown.get_item_metadata(subrace_dropdown.selected)
	current_subrace_id = meta if meta != null else ""

func _read_current_gender() -> void:
	var male_button = gender_selector.get_node("male_button")
	current_gender = "m" if male_button.is_pressed() else "f"

func _update_label() -> void:
	text = build_selection_key()
	portrait_display.display_from_key(text)

func build_selection_key() -> String:
	if current_subrace_id == "":
		return "%s_%s" % [current_race_id, current_gender]
	var subrace_part = current_subrace_id.replace("-", "_").split("_")[0]
	return "%s_%s_%s" % [current_race_id, subrace_part, current_gender]
