extends RichTextLabel

func _ready():
	# 1. Get the font from your 'Normal Font' slot
	var base_font = get_theme_font("normal_font")
	
	# 2. Create a 'Variation' of that font in memory
	var v_font = FontVariation.new()
	v_font.base_font = base_font
	
	# 3. Inject the OpenType features directly into the font settings
	# This turns on the RO connection and the sharp N, S, T
	v_font.opentype_features = {
		"dlig": 1,
		"ss02": 1
	}
	
	# 4. Tell this Label to use our modified font variation
	add_theme_font_override("normal_font", v_font)
	
	# 5. Set the text as a PLAIN string. No brackets, no code.
	self.text = "IRON DUST"
	
	# 6. Safety settings
	self.autowrap_mode = TextServer.AUTOWRAP_OFF
