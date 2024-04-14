extends Area2D

@export var game: Node2D
@onready var FireOrigin = $Visual/Body/LeftArm/Hand/FireOrigin

signal enemy_died(nodex)

var Bullet = load("res://Components/Bullet/bullet.tscn")

var dead = false

func _ready():
	assert(game)

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

func _on_area_entered(area):
	if dead:
		return

	if area.is_in_group("Weapon") and area.attacking:
		die()
