extends TextureRect

@export var tooltip_max_width: float = 250.0
@export var tooltip_margin_left: int = 8
@export var tooltip_margin_top: int = 3
@export var tooltip_margin_right: int = 0
@export var tooltip_margin_bottom: int = 3

func _make_custom_tooltip(for_text: String) -> Object:
	var label := Label.new()
	label.text = for_text
	label.theme_type_variation = "TooltipLabel"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(tooltip_max_width, 0)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", tooltip_margin_left)
	margin.add_theme_constant_override("margin_top", tooltip_margin_top)
	margin.add_theme_constant_override("margin_right", tooltip_margin_right)
	margin.add_theme_constant_override("margin_bottom", tooltip_margin_bottom)
	margin.add_child(label)

	var panel := PanelContainer.new()
	panel.theme_type_variation = "TooltipPanel"
	panel.add_child(margin)

	return panel
