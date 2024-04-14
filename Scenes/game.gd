extends Node2D

var Heart = load("res://Components/Heart/heart.tscn")

@onready var ui_anim: AnimationPlayer = $UI/AnimationPlayer
@onready var ui = $UI

@export var player: CharacterBody2D
@export var cthulhu: Node2D
@export var camera: Camera2D

var paused = false

func _ready():
	randomize()
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
	player.update_abilities(deal)
	perform_global_perk(deal)

func _on_cthullu_on_summon():
	camera.shake(1, 80, 30)
	ui_anim.play("ShowDaemonVignette")
	player.stop_walking()
	paused = true

func _on_cthullu_on_gone():
	camera.shake(0.8, 50, 20)
	ui_anim.play("HideDaemonVignette")
	paused = false

## GLOBAL CTHULHU EVENTS ################
func perform_global_perk(deal):
	if deal.ability.has('code'):
		match deal.ability.code:
			'kill_random': kill_random_enemy()
			'kill_all': kill_all_enemies()

func kill_random_enemy():
	var alive = []
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.is_alive():
			alive.append(enemy)
	var idx = randi() % alive.size()
	alive[idx].die()

func kill_all_enemies():
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.is_alive():
			enemy.die()


func _on_insta_kill_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
