extends Area2D

@export var cthulhu: Node2D

var enabled = false

func _ready():
	assert(cthulhu)

func _input(event):
	if !enabled:
		return

	if Input.is_action_just_pressed("ui_accept"):
		cthulhu.summon()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		enabled = true
		$Info.show()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		enabled = false
		$Info.hide()
