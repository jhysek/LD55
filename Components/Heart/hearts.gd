extends Control

@export var value = 1

func change(new_value):
	if new_value != value:
		value = new_value
		$Container/Label.text = str(new_value)
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property($Container, 'scale', 1.2, 0.5)

		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property($Container, 'scale', 1.0, 0.5)
