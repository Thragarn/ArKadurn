extends RichTextLabel

@export var A_height_font := 0.03
@export var B_height_font := -0.2
@export var C_height_font := 26.4
var _template: String = ""

func _ready() -> void:
	_template = text

func display_average_height(txtheight_value) -> void:
	var content: String = "" if txtheight_value == null else str(txtheight_value)
	var char_count: int = content.length()

	var font_size: int = int(ceil(C_height_font + (B_height_font * char_count) + (A_height_font * (char_count^2))))
	font_size = clampi(font_size, 8, 26)  # safety net so it can never hit 0 or negative on a very long stringg

	var sized_chunk := "[font_size=%d]%s[/font_size]" % [font_size, content]
	text = _template.replace("{avgh}", sized_chunk)
