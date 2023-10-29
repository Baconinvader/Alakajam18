extends Interactable

var concealing_player:bool = false

func _get_can_interact() -> bool:
	if $interact_cooldown.time_left:
		return false
	return true

func interact():
	$interact_cooldown.start()
	concealing_player = not concealing_player
	if concealing_player:
		g.player.visible = false
		g.player.position = position
		$hide_in_sound.play()
	else:
		g.player.visible = true
		g.player.position = position + $exit.position
		$hide_out_sound.play()
