extends Area2D

@export var speed_multiplicator = 1.0

@export var game: Node2D
@onready var FireOrigin = $Visual/Body/LeftArm/Hand/FireOrigin

signal enemy_died(nodex)

var Bullet = load("res://Components/Bullet/bullet.tscn")

var dead = false

func _ready():
	$AnimationPlayer.speed_scale = $AnimationPlayer.speed_scale * speed_multiplicator
	assert(game)

func is_alive():
	return !dead

func spawn_bullet():
	var bullet = Bullet.instantiate()
	bullet.name = "Bullet"
	FireOrigin.add_child(bullet)

func fire():
	if FireOrigin.has_node("Bullet"):
		$Sfx/Shoot.play()
		var bullet = $Visual/Body/LeftArm/Hand/FireOrigin/Bullet
		bullet.reparent(game)
		bullet.fire(Vector2.RIGHT)

func hit():
	# TODO: postupna likvidace?
	die()

func die():
	if dead:
		return

	dead = true
	if FireOrigin.has_node("Bullet"):
		$Visual/Body/LeftArm/Hand/FireOrigin/Bullet.queue_free()

	$Sfx/Hit.play()
	$Sfx/Dead.play()
	$AnimationPlayer.play("Die")
	$BloodSplash.emitting = true
	emit_signal("enemy_died", self)
	free_unnecessary()

func free_unnecessary():
	process_mode = Node.PROCESS_MODE_DISABLED
	monitoring = false
	monitorable = false

func _on_area_entered(area):
	if dead:
		return

	if area.is_in_group("Weapon") and area.attacking:
		die()
