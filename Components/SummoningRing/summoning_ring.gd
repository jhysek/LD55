extends Area2D

@export var menu: Panel

var enabled = false

func _ready():
	assert(menu)

func _input(event):
	if !enabled:
		return

	if Input.is_action_just_pressed("ui_accept"):
		menu.appear()
		print("SUMMON!")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		enabled = true
		$Info.show()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		enabled = false
		$Info.hide()
