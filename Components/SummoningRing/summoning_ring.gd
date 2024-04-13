extends Area2D

@export var cthulhu: Node2D

var enabled = false

func _ready():
	assert(cthulhu)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$Timer.start()
		enabled = true

func _on_body_exited(body):
	if body.is_in_group("Player"):
		enabled = false

func _on_timer_timeout():
	cthulhu.summon()
