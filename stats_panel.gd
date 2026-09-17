extends VBoxContainer

@export_group("Stat Value Colors")
@export var positive_color: Color = Color(0.4, 0.85, 0.4)
@export var negative_color: Color = Color(0.9, 0.35, 0.35)
@export var neutral_color: Color = Color(0.85, 0.85, 0.85)

func display_race_stats(race_id: String) -> void:
	var race_data: Dictionary = DataManager.races.get(race_id, {})
	for row in get_children():
		if row.has_method("set_stat_value"):
			row.set_stat_value(race_data.get(row.stat_key, null))

func get_color_for_value(value: float) -> Color:
	if value > 0:
		return positive_color
	elif value < 0:
		return negative_color
	else:
		return neutral_color
