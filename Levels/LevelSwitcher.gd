extends Node

var current_level = 0
var abilities = {
	'doublejump' = {
		ability = {
			name = "Double Jump",
			code = 'doublejump'
		},
		price = {
			lives = 2
		}
	},
	'fly' = {
		ability = {
			name = "Flying",
			code = 'fly'
		},
		price = {
			lives = 2
		}
	},
	'attack' = {
		ability = {
			name = "Attack",
			code = 'attack'
		},
		price = {
			lives = 2
		}
	},
	'attack_for_doublejump' = {
		ability = {
			name = "Attack",
			code = 'attack'
		},
		price = {
			name = 'Double Jump',
			code = 'doublejump'
		}
	},
	'lives_for_jump' = {
		ability = {
			lives = 3
		},
		price = {
			name = 'Jump',
			code = 'jump'
		}
	}
}

var levels = [


	{
		scene = "res://Levels/level01.tscn",
		deals = {}
	},

	{
		scene = "res://Levels/level03.tscn",
		deals = {}
	},

	{
		scene = "res://Levels/level02.tscn",
		deals = {
			'attack': abilities.attack,
			'doublejump': abilities.doublejump,
			'quit': {}
		}
	},

	{
		scene = "res://Levels/level04.tscn",
		deals = {
			'attack': abilities.attack_for_doublejump,
			'doublejump': abilities.doublejump,
			'lives': abilities.lives_for_jump,
			'quit': {}
		}
	},

	{
		scene = "res://Levels/finished.tscn"
	}
]

func _ready():
	set_process_input(true)

func _input(event):
	if Input.is_action_just_released("ui_restart"):
		restart_level()

	if Input.is_key_pressed(KEY_4):
		current_level = 3
		start_level()

func get_current_level():
	return levels[current_level]

func get_current_deals():
	if levels[current_level] && levels[current_level].has('deals'):
		return levels[current_level].deals
	else:
		return {}

func restart_level():
	get_tree().reload_current_scene()

func start_level():
	Transition.switchTo(levels[current_level].scene)

func next_level():
	print("LEVEL: " + str(current_level) + " DONE")
	current_level += 1

	print("Switching to: " + str(current_level) + " / " + levels[current_level].scene)
	if current_level < levels.size():
		start_level()

