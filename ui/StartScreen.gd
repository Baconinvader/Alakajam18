extends Control


func _ready():
	g.in_game = false

func _on_start_button_pressed():
	g.overlay.start(Color.TRANSPARENT, Color.BLACK, 1.0)
	g.overlay.connect("finished", _on_overlay_finished, CONNECT_ONE_SHOT)
	Sound.play_sound("button1")
	
func _on_overlay_finished():
	g.overlay.start(Color.BLACK, Color.TRANSPARENT, 1.0)
	g.main.start_game()
	queue_free()
