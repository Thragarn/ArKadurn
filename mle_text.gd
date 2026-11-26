extends RichTextLabel

var _template: String = ""

func _ready() -> void:
	# Capture your original BBCode-styled text, placeholder and all, before anything overwrites it
	_template = text

func display_lifespan(lifespan_value) -> void:
	var numeric_value: float = 0.0 if lifespan_value == null else float(lifespan_value)
	var formatted := str(int(round(numeric_value))) + " Years"
	text = _template.replace("{lifespan}", formatted)
