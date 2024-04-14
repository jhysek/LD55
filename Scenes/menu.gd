extends Node2D

func _ready():
	Transition.openScene()
	$Cthullu.summon()

func _on_button_mouse_entered():
	$Sfx/Hover.play()

func _on_button_mouse_exited():
	$Sfx/Hover.play()

func play(name):
	if $Sfx.has_node(name):
		$Sfx.get_node(name).play

func _on_button_2_pressed():
	$Sfx/Click.play()
	LevelSwitcher.start_level()
