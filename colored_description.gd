extends RichTextLabel
class_name DescriptionDisplay

@export var bold_word_color: Color = Color.YELLOW

func display_formatted_text(raw_text: String) -> void:
	var hex_code = bold_word_color.to_html(false)
	var formatted_text = raw_text.replace("[b]", "[b][color=#" + hex_code + "]")
	formatted_text = formatted_text.replace("[/b]", "[/color][/b]")
	text = formatted_text

func display_missing_race_message(race_id: String) -> void:
	text = "[color=red]Missing description file for: " + race_id + "[/color]"
