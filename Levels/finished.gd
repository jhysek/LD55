extends Node2D

func _ready():
	Music.stop()
	Music.seek(0)
	Music.play()
	$Cthullu.summon()
	$Camera.shake(1, 80, 30)
	Transition.openScene()

func back_off():
	$Cthullu.back_off()

func _on_button_pressed():
	LevelSwitcher.current_level = 0
	Transition.switchTo("res://Scenes/menu.tscn")
