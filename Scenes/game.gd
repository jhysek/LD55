extends Node2D

@onready var ui_anim: AnimationPlayer = $UI/AnimationPlayer
@onready var timer: Label = $UI/Timer

@export var player: CharacterBody2D
@export var cthulhu: Node2D
@export var camera: Camera2D


var paused = false

func _ready():
	assert(player)
	Transition.openScene()
	timer.start()

func _on_daemon_menu_deal(deal):
	print("DEAL WITH DEVIL HAS BEEN MADE!" + str(deal))
	player.update_abilities(deal)

func _on_daemon_menu_on_opened():
	cthulhu.summon()
	#camera.zoom_out()
	camera.shake(1, 80, 30)
	ui_anim.play("ShowDaemonVignette")
	timer.pause()
	paused = true

func _on_daemon_menu_on_closed():
	cthulhu.back_off()
	camera.shake(0.8, 50, 20)
	#camera.zoom_to_normal()
	ui_anim.play("HideDaemonVignette")
	timer.resume()
	paused = false

func _on_exit_exit_reached():
	Transition.switchTo("res://Scenes/game.tscn")
