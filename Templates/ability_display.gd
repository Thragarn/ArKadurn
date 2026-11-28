extends VBoxContainer

@onready var head_label: Label = %Abilityhead
@onready var text_label: RichTextLabel = %abilitytext

func set_ability(title: String, bbcode: String) -> void:
	head_label.text = title
	text_label.bbcode_enabled = true
	text_label.text = bbcode
