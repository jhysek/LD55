extends Area2D

@export var cthulhu: Node2D
@export var STATIC: bool = false

var enabled = false

func _ready():
	if !STATIC:
		assert(cthulhu)

func _on_body_entered(body):
	if !STATIC and body.is_in_group("Player"):
		$Timer.start()
		enabled = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		enabled = false

func _on_timer_timeout():
	cthulhu.summon()
