extends Node2D

var fired = false
var SPEED = 2000
@export var direction = Vector2.RIGHT
var flying_time = 0

func fire(to_direction = Vector2.RIGHT):
	direction = to_direction
	fired = true

func _process(delta):
	if fired:
		position = position + direction * SPEED * delta
		flying_time += delta

		if flying_time > 5:
			queue_free()


func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		body.hit()
		queue_free()
