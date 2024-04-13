extends Panel

signal deal(data)
signal on_opened
signal on_closed

@onready var anim = $AnimationPlayer

var deals = {
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
			name = "Flying / flapping",
			code = 'fly'
		},
		price = {
			lives = 2
		}
	}
}

var activated = false

func appear():
	if activated:
		return

	activated = true
	emit_signal("on_opened")
	anim.play("Show")

func make_a_deal(ability):
	if !activated:
		return

	if deals.has(ability):
		emit_signal("deal", deals[ability])
		emit_signal("on_closed")
		anim.play("Hide")
	else:
		assert(false, "No such ability: " + str(ability))

func _on_button_2_pressed():
	if !activated:
		return

	emit_signal("on_closed")
	anim.play("Hide")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Hide":
		activated = false
