# skill_row_template.gd
extends HBoxContainer

@export_group("Score Colors")
@export var positive_color: Color = Color(0.4, 0.85, 0.4)
@export var negative_color: Color = Color(0.9, 0.35, 0.35)

@onready var name_label: Label = %skillname
@onready var score_label: Label = %skillscore

func set_skill(skill_key: String, value: int) -> void:
	var skill_info: Dictionary = DataManager.skills.get(skill_key, {})
	name_label.text = skill_info.get("full_name", skill_key)  # fallback to raw key if missing
	score_label.text = ("+" if value > 0 else "") + str(value)
	score_label.add_theme_color_override(
		"font_color",
		positive_color if value > 0 else negative_color
	)
