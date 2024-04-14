extends Node2D

var Heart = load("res://Components/Heart/heart.tscn")

@onready var ui_anim: AnimationPlayer = $UI/AnimationPlayer
@onready var ui = $UI

@export var player: CharacterBody2D
@export var cthulhu: Node2D
@export var camera: Camera2D


var paused = false

func _ready():
	assert(player)
	assert(cthulhu)
	assert(camera)

	cthulhu.player = player

	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.enemy_died.connect(_on_enemy_died)

	Transition.openScene()
	ui.show()
	ui.change_hearts(player.lives)

## ENEMY CALLBACKS ###############################
func _on_enemy_died(enemy):
	player.lives += 1
	camera.shake(0.2, 80, 20)
	ui.change_hearts(player.lives)
	var heart = Heart.instantiate()
	add_child(heart)
	heart.position = enemy.position
	heart.start(enemy.position)

## PLAYER CALLBACKS ###############################
func _on_player_on_hit(lives):
	ui.change_hearts(lives)

func _on_player_died():
	ui.change_hearts(0)
	LevelSwitcher.restart_level()

func _on_exit_exit_reached():
	LevelSwitcher.next_level()

## CTHULHU CALLBACKS ##############################
func _on_cthullu_deal(deal):
	print("NEW DEAL HAS BEEN MADE: " + str(deal))
	player.update_abilities(deal)

func _on_cthullu_on_summon():
	camera.shake(1, 80, 30)
	ui_anim.play("ShowDaemonVignette")
	paused = true

func _on_cthullu_on_gone():
	camera.shake(0.8, 50, 20)
	ui_anim.play("HideDaemonVignette")
	paused = false
