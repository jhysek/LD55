extends Node2D

func _ready():
	Transition.openScene()

func _on_button_pressed():
	LevelSwitcher.current_level = 0
	Transition.switchTo("res://Scenes/menu.tscn")
