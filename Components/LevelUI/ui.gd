extends CanvasLayer

@export var show_timer = true

func _ready():
	$Timer.visible = show_timer
func change_hearts(value):
	$Hearts.change(value)
