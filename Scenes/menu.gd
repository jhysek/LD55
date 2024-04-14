extends Node2D

func _ready():
	Transition.openScene()

func _on_button_pressed():
	play("Click")
	LevelSwitcher.start_level()

func _on_button_mouse_entered():
	play("Hover")

func _on_button_mouse_exited():
	play("Hover")

func play(name):
	if $Sfx.has_node(name):
		$Sfx.get_node(name).play

