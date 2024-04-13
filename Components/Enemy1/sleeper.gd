extends Area2D

var aware = false
enum State {
	SLEEPING,
	AWAKE,
	ATTACKING,
	DEAD
}

@export var state: State = State.SLEEPING

@onready var anim: AnimationPlayer = $AnimationPlayer

func change_state(to):
	state = to
	match state:
		State.SLEEPING:
			aware = false
			$Body.region_rect = Rect2(0, 200, 380, 200)
			$Timeout.stop()
		State.AWAKE:
			aware = true
			$Body.region_rect = Rect2(0, 0, 380, 200)
			$Timeout.start()
		State.ATTACKING:
			$Body.region_rect = Rect2(0, 400, 380, 200)

func _on_area_entered(area):
	if state == State.DEAD:
		return

	if area.is_in_group("Weapon") and area.attacking:
		die()

func die():
	state = State.DEAD

func attack():
	change_state(State.ATTACKING)
	anim.play("Attack")
	$Timeout.stop()
	$Timeout.start()

func _on_spike_body_entered(body):
	if body.is_in_group("Player"):
		body.hit()

func _on_aware_area_body_entered(body):
	if body.is_in_group("Player"):
		aware = true
		if state == State.SLEEPING:
			change_state(State.AWAKE)

func _on_aware_area_body_exited(body):
	if body.is_in_group("Player"):
		aware = false

func _on_timeout_timeout():
	print("TICK")
	match state:
		State.AWAKE:
			attack()

		State.ATTACKING:
			print("AWARE: " + str(aware))
			if aware:
				attack()
			else:
				change_state(State.SLEEPING)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		if aware:
			attack()