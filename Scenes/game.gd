extends Node2D

@onready var ui_anim: AnimationPlayer = $UI/AnimationPlayer
@onready var timer: Label = $UI/Timer
@onready var ui = $UI

@export var player: CharacterBody2D
@export var cthulhu: Node2D
@export var camera: Camera2D

var paused = false

func _ready():
	assert(player)
	assert(cthulhu)
	assert(camera)

	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.enemy_died.connect(_on_enemy_died)

	Transition.openScene()
	timer.start()
	ui.change_hearts(player.lives)

## ENEMY CALLBACKS ###############################
func _on_enemy_died(enemy):
	player.lives += 1
	ui.change_hearts(player.lives)

## PLAYER CALLBACKS ###############################
func _on_player_on_hit(lives):
	ui.change_hearts(lives)

func _on_player_died():
	ui.change_hearts(0)
	LevelSwitcher.restart_level()

func _on_exit_exit_reached():
	Transition.switchTo("res://Scenes/game.tscn")

## CTHULHU CALLBACKS ##############################
func _on_cthullu_deal(deal):
	print("NEW DEAL HAS BEEN MADE: " + str(deal))
	player.update_abilities(deal)

func _on_cthullu_on_summon():
	camera.shake(1, 80, 30)
	ui_anim.play("ShowDaemonVignette")
	timer.pause()
	paused = true

func _on_cthullu_on_gone():
	camera.shake(0.8, 50, 20)
	ui_anim.play("HideDaemonVignette")
	timer.resume()
	paused = false
