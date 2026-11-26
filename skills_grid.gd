extends HBoxContainer

@export var skill_row_template: PackedScene

@onready var negative_column: VBoxContainer = $NegativeSkills
@onready var positive_column: VBoxContainer = $PositiveSkills

@export var no_skills_message: Control 

const SKILL_KEYS: Array[String] = [
	"kn_nat", "kn_sci", "kn_hist", "percep", "lang",
	"cr_met", "cr_tex", "cr_art", "persua", "perform",
	"magic", "mentalRR", "acroRR", "stealth",
	"w_light", "w_vers", "w_great", "w_range",
	"athlc_RR", "h2h", "bending", "phy_RR"
]

func display_race_skills(race_id: String) -> void:
	for child in negative_column.get_children():
		child.queue_free()
	for child in positive_column.get_children():
		child.queue_free()

	if skill_row_template == null:
		push_warning("SkillsGrid: no skill_row_template assigned in the Inspector.")
		return

	var race_data: Dictionary = DataManager.races.get(race_id, {})
	var added_rows := 0

	for skill_key in SKILL_KEYS:
		var raw_value = race_data.get(skill_key, null)
		if raw_value == null:
			continue

		var int_value := int(round(float(raw_value)))
		var row = skill_row_template.instantiate()

		if int_value < 0:
			negative_column.add_child(row)
		else:
			positive_column.add_child(row)

		row.set_skill(skill_key, int_value)
		added_rows += 1

	no_skills_message.visible = added_rows == 0
