extends Node2D

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Summon":
		$AnimationPlayer.play("Idle")

func summon():
	$AnimationPlayer.play("Summon")

func back_off():
	$AnimationPlayer.play_backwards("Summon")
