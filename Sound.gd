extends Node

var current_path:String = ""

func play_sound(sound_name:String):
	var path:String = "res://assets/audio/%s.wav" % sound_name
	if current_path != path:
		
		var stream = load(path)
		$player1.stream = stream
		$player1.stop()
		current_path = path
	$player1.play()
