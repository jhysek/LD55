extends Area2D

signal enemy_died(enemy)

var aware = false
var spike_cooldown = 0

enum State {
	SLEEPING,
	AWAKE,
	ATTACKING,
	DEAD
}

@export var state: State = State.SLEEPING

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready():
	change_state(state)

func _process(delta):
	if spike_cooldown > 0:
		spike_cooldown -= delta
	else:
		spike_cooldown = 0

func is_alive():
	return state != State.DEAD

func change_state(to):
	state = to
	match state:
		State.SLEEPING:
			aware = false
			anim.play("Idle")
			$Body.region_rect = Rect2(0, 200, 380, 200)
			$Timeout.stop()
		State.AWAKE:
			aware = true
			var i = randi() % 3 + 1
			get_node("Sfx/Awake" + str(i)).play()
			$Body.region_rect = Rect2(0, 0, 380, 200)
			$Timeout.start()
		State.ATTACKING:
			$Body.region_rect = Rect2(0, 400, 380, 200)
		State.DEAD:
			$Body.region_rect = Rect2(0, 200, 380, 200)
			anim.play("Die")
			$Sfx/Hit.play()
			var i = randi() % 2 + 1
			get_node("Sfx/Dead" + str(i)).play()
			$Splash.show()
			emit_signal("enemy_died", self)
			$BloodSplash.emitting = true


func _on_area_entered(area):
	if state == State.DEAD:
		return

	if area.is_in_group("Weapon") and area.attacking:
		die()

func hit():
	die()

func free_unnecessary():
	monitorable = false
	monitoring = false
	process_mode = Node.PROCESS_MODE_DISABLED
	$Body/Tongue/Spike.queue_free()
	$AwareArea.queue_free()

func die():
	if state != State.DEAD:
		change_state(State.DEAD)

func attack():
	change_state(State.ATTACKING)
	anim.play("Attack")
	$Timeout.stop()
	$Timeout.start()

func _on_spike_body_entered(body):
	if spike_cooldown <= 0 and body.is_in_group("Player"):
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
	match state:
		State.AWAKE:
			attack()

		State.ATTACKING:
			if aware:
				attack()
			else:
				change_state(State.SLEEPING)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		if aware:
			attack()
