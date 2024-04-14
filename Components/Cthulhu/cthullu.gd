extends Node2D

@export var debug_level_idx: int;
@export var player: CharacterBody2D
@export var STATIC: bool = false

var DealButton = load("res://Components/DealButton/button.tscn")

signal deal(data: Dictionary)
signal on_summon
signal on_gone

var summoned = false

var deals = {}

func _ready():
	var idx = 0

	if debug_level_idx:
		LevelSwitcher.current_level = debug_level_idx

	deals = LevelSwitcher.get_current_deals()

	for code in deals:
		var deal = deals[code]
		var button = DealButton.instantiate()
		if code == 'quit':
			button.set_quit_btn()
			button.pressed.connect(func(): back_off())
		else:
			button.set_deal(deal)
			button.pressed.connect(func(): make_deal(deal))

		$Deals.add_child(button)
		button.position = Vector2(0, 0)
		button.set_meta('target', Vector2(0, idx * 200))
		button.modulate = Color(1,1,1,0.0)
		deals[code]['node'] = button
		idx += 1

func show_deals():
	var idx = 0
	for code in deals:
		var deal = deals[code]

		if deal.has('price'):
			if player.can_pay(deal.price) and player.can_get_product(deal.ability):
				deal.node.enable()
			else:
				deal.node.disable()

		var tween = create_tween().set_parallel(true)
		tween.tween_property(deal.node, 'position', deal.node.get_meta('target'), 1).set_delay(2 + idx * 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(deal.node, 'modulate', Color(1,1,1,1.0), 0.5).set_delay(2 + idx * 0.2)
		idx += 1

func hide_deals():
	var idx = 0
	for code in deals:
		var deal = deals[code]
		var tween = create_tween().set_parallel(true)
		tween.tween_property(deal.node, 'position', Vector2.ZERO, 1).set_delay(idx * 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(deal.node, 'modulate', Color(1,1,1,0.0), 0.5)
		idx += 1

func make_deal(deal):
	$Sfx/Deal.play()
	emit_signal("deal",  deal)
	back_off()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Summon":
		$AnimationPlayer.play("Idle")

func summon():
	if summoned:
		return
	if !STATIC:
		$Sfx/Summon.play()
		$Sfx/Summon2.play()
	summoned = true
	show_deals()
	emit_signal('on_summon')
	$AnimationPlayer.play("Summon")

func back_off():
	hide_deals()
	emit_signal('on_gone')
	$AnimationPlayer.play_backwards("Summon")
	summoned = false

