extends Node

var current_level = 0
var abilities = {
	'jump' = {
		ability = {
			name = "Jumping",
			code = 'jump'
		},
		price = {
			lives = 4
		}
	},
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
			lives = 3
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
			name = 'Jumping',
			code = 'jump'
		}
	},
	'lives_for_doublejump' = {
		ability = {
			lives = 3
		},
		price = {
			name = 'Double Jump',
			code = 'doublejump'
		}
	},
	'kill_random' = {
		ability = {
			name = "Kill random",
			code = 'kill_random'
		},
		price = {
			lives = 3
		}
	},
		'kill_random_2' = {
		ability = {
			name = "Kill random",
			code = 'kill_random'
		},
		price = {
			lives = 2
		}
	},

	'kill_all' = {
		ability = {
			name = "Kill all",
			code = 'kill_all'
		},
		price = {
			name = 'Jump',
			code = 'jump'
		}
	},
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
		scene = "res://Levels/level05.tscn",
		deals = {
			'jump': abilities.jump,
			'doublejump': abilities.doublejump,
			'kill_random': abilities.kill_random,
			'kill_all': abilities.kill_all,
			'quit': {}
		}
	},

	{
		scene = "res://Levels/level06.tscn",
		deals = {
			'lives_for_doublejump': abilities.lives_for_doublejump,
			'fly': abilities.fly,
			'kill_random': abilities.kill_random_2,

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

	if Input.is_key_pressed(KEY_N) and Input.is_key_pressed(KEY_SHIFT):
		next_level()

	if Input.is_key_pressed(KEY_6):
		current_level = 5
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

