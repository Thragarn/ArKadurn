extends RichTextLabel

func display_lifespan(race_id: String) -> void:
	var race_data: Dictionary = DataManager.races.get(race_id, {})
	var raw_lifespan = race_data.get("lifespan", null)
	var lifespan_value: int = 0 if raw_lifespan == null else int(round(float(raw_lifespan)))
	text = "%d years" % lifespan_value
