extends VBoxContainer

enum Source { ASSETS, HANDICAPS }

@export var source: Source = Source.ASSETS
@export var ability_template: PackedScene
@export var no_entries_message: Control

@export_group("Bold Text")
@export var bold_font: Font                      ## Empty = keep the template's bold font
@export var bold_font_size: int = 0              ## 0 = keep the template's size
@export var bold_color: Color = Color.WHITE
@export var bold_outline_size: int = 0
@export var bold_outline_color: Color = Color.BLACK

func display_race_abilities(race_id: String, plural: String) -> void:
	for child in get_children():
		child.queue_free()

	if ability_template == null:
		push_warning(name + ": no ability_template assigned in the Inspector.")
		return

	var column := "assets" if source == Source.ASSETS else "handicaps"
	var database: Dictionary = DataManager.assets if source == Source.ASSETS else DataManager.handicaps
	var raw = DataManager.races.get(race_id, {}).get(column, null)
	var added_rows := 0

	if raw != null:
		for key in str(raw).replace('"', '').split(",", false):
			var ability_id: String = key.strip_edges()
			if ability_id.is_empty():
				continue
			if not database.has(ability_id):
				push_warning("Unknown " + column + " id: " + ability_id)
				continue

			var row = ability_template.instantiate()
			add_child(row)  # must come BEFORE set_ability (@onready)
			row.set_ability(ability_id.capitalize(), _build_description(database[ability_id], plural))
			_apply_bold_font(row.text_label)
			added_rows += 1

	if no_entries_message:
		no_entries_message.visible = added_rows == 0


func _build_description(entry: Dictionary, plural: String) -> String:
	var values := {"plural": plural}
	for effect in entry.get("effects", []):
		if effect.has("modifier") and effect.has("value"):
			values[effect["modifier"]] = _format_number(effect["value"])
	var text: String = str(entry.get("description", "")).format(values)
	return _style_bold(text)


func _format_number(v) -> String:
	if typeof(v) == TYPE_FLOAT and is_equal_approx(v, round(v)):
		return str(int(v))
	return str(v)


func _style_bold(text: String) -> String:
	var open := "[b][color=#%s][outline_size=%d][outline_color=#%s]" % [
		bold_color.to_html(true), bold_outline_size, bold_outline_color.to_html(true)]
	var close := "[/outline_color][/outline_size][/color][/b]"
	return text.replace("[b]", open).replace("[/b]", close)


func _apply_bold_font(label: RichTextLabel) -> void:
	if bold_font:
		label.add_theme_font_override("bold_font", bold_font)
	if bold_font_size > 0:
		label.add_theme_font_size_override("bold_font_size", bold_font_size)
