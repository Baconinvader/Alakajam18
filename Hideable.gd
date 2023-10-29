extends Interactable

var concealing_player:bool = false

var closed_texture:Texture2D = load("res://assets/visual/objects/locker.png")
var open_texture:Texture2D = load("res://assets/visual/objects/locker_open.png")

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
		
	play_open_anim()
	
func play_open_anim():
	var open_tween:Tween = create_tween()
	open_tween.tween_property($sprite, "texture", open_texture, 0.15)
	open_tween.tween_interval(0.5)
	open_tween.tween_property($sprite, "texture", closed_texture, 0.1)
