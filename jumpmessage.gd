# follow_control.gd — attach to your CenterContainer (the message container)
extends Control

## Makes this Control always match the size and position of `target`
## while the game is running. Purely a runtime effect — doesn't touch
## the editor layout, so you're free to place this node wherever's
## convenient (including off-screen) in the 2D view.

@export var target: Control

func _process(_delta: float) -> void:
	if target == null:
		return
	global_position = target.global_position
	size = target.size
